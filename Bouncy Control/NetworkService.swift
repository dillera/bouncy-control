import Foundation

protocol NetworkServicing {
    func sendCommand(to server: Server, endpoint: String) async throws
    func sendBroadcast(to server: Server, message: String, displayTime: Int) async throws
    func fetchStatus(from server: Server) async throws -> BouncyWorldStatus
}

protocol URLSessionProviding {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProviding {}

final class NetworkService: ObservableObject, NetworkServicing {
    enum NetworkError: LocalizedError, Equatable {
        case invalidURL(String)
        case invalidResponse
        case httpError(Int)
        case noData
        case decodingFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidURL(let url):
                return "Invalid URL: \(url)"
            case .invalidResponse:
                return "Invalid response from server"
            case .httpError(let code):
                return "HTTP error: \(code)"
            case .noData:
                return "No data received from server"
            case .decodingFailed:
                return "Failed to decode server response"
            }
        }
    }

    private let session: URLSessionProviding

    init(session: URLSessionProviding = URLSession.shared) {
        self.session = session
    }
    
    func sendCommand(to server: Server, endpoint: String) async throws {
        let finalURL = try makeURL(for: server, endpoint: endpoint)
        let (_, response) = try await session.data(from: finalURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
    }
    
    func sendBroadcast(to server: Server, message: String, displayTime: Int) async throws {
        guard !message.isEmpty else {
            throw NetworkError.invalidURL("Message cannot be empty")
        }
        
        guard displayTime > 0 else {
            throw NetworkError.invalidURL("Display time must be greater than 0")
        }
        
        let formattedMessage = message
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
        let endpoint = "/cmd/broadcast/ALL/\(displayTime)/\(formattedMessage)"
        
        try await sendCommand(to: server, endpoint: endpoint)
    }

    func fetchStatus(from server: Server) async throws -> BouncyWorldStatus {
        let finalURL = try makeURL(for: server, endpoint: "/status")
        let (data, response) = try await session.data(from: finalURL)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try JSONDecoder().decode(BouncyWorldStatus.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    private func makeURL(for server: Server, endpoint: String) throws -> URL {
        guard let baseURL = URL(string: server.url),
              let scheme = baseURL.scheme?.lowercased(),
              scheme == "http" || scheme == "https" else {
            throw NetworkError.invalidURL(server.url)
        }

        var finalURL = baseURL
        let segments = endpoint.split(separator: "/", omittingEmptySubsequences: true)

        for segment in segments {
            finalURL.appendPathComponent(String(segment))
        }

        return finalURL
    }
}
