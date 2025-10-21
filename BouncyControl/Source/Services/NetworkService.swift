//
//  NetworkService.swift
//  BouncyControl
//
//  Created on 10/21/2025.
//

import Foundation

/// Network service for communicating with Bouncy Worlds API
class NetworkService {
    static let shared = NetworkService()

    // MARK: - Properties

    private let baseURL: String
    private let session: URLSession

    // MARK: - Initialization

    init(baseURL: String = "https://api.bouncyworlds.com", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - Public Methods

    /// Fetches the list of available worlds
    func fetchWorlds() async throws -> [BouncyWorld] {
        let endpoint = "\(baseURL)/worlds"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let worldsResponse = try decoder.decode(WorldsResponse.self, from: data)
        return worldsResponse.worlds
    }

    /// Starts a specific world
    func startWorld(worldId: String) async throws -> ControlResponse {
        try await sendControlCommand(worldId: worldId, action: "start")
    }

    /// Stops a specific world
    func stopWorld(worldId: String) async throws -> ControlResponse {
        try await sendControlCommand(worldId: worldId, action: "stop")
    }

    /// Restarts a specific world
    func restartWorld(worldId: String) async throws -> ControlResponse {
        try await sendControlCommand(worldId: worldId, action: "restart")
    }

    // MARK: - Private Methods

    private func sendControlCommand(worldId: String, action: String) async throws -> ControlResponse {
        let endpoint = "\(baseURL)/worlds/\(worldId)/\(action)"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let controlResponse = try decoder.decode(ControlResponse.self, from: data)
        return controlResponse
    }
}

// MARK: - Network Errors

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
