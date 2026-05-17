import XCTest
@testable import Bouncy_Control

final class NetworkServiceTests: XCTestCase {
    override func tearDown() {
        URLProtocolMock.handler = nil
        super.tearDown()
    }

    func testSendCommandWithInvalidURLThrowsError() async {
        let service = makeService()
        let server = Server(name: "Test", url: "invalid-url")

        do {
            try await service.sendCommand(to: server, endpoint: "/reset")
            XCTFail("Expected invalid URL error")
        } catch let error as NetworkService.NetworkError {
            XCTAssertEqual(error.errorDescription, "Invalid URL: invalid-url")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSendBroadcastEncodesMessageAndUsesCommandPath() async throws {
        let expectedPath = "/cmd/broadcast/ALL/15/Hello_there_General"
        let service = makeService { request in
            XCTAssertEqual(request.url?.absoluteString, "http://example.com\(expectedPath)")
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, Data())
        }

        let server = Server(name: "Test", url: "http://example.com")
        try await service.sendBroadcast(to: server, message: "Hello there/General", displayTime: 15)
    }

    func testFetchStatusDecodesWorldStatus() async throws {
        let payload = """
        {
          "width": 40,
          "height": 24,
          "frozen": false,
          "wrapping": true,
          "bodyCounts": [{"size": 1, "count": 2}],
          "bodies": [{
            "id": 7,
            "radius": 2.5,
            "mass": 4.6,
            "position": {"x": 13.0, "y": 5.4},
            "velocity": {"x": 4.5, "y": 5.4}
          }],
          "clients": [{"name": "operator", "host": "127.0.0.1"}]
        }
        """.data(using: .utf8)!

        let service = makeService { request in
            XCTAssertEqual(request.url?.absoluteString, "http://example.com/status")
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, payload)
        }

        let status = try await service.fetchStatus(from: Server(name: "Test", url: "http://example.com"))

        XCTAssertEqual(status.width, 40)
        XCTAssertEqual(status.height, 24)
        XCTAssertEqual(status.totalBodies, 2)
        XCTAssertEqual(status.bodies.first?.id, 7)
        XCTAssertEqual(status.clients.first?.description, "host: 127.0.0.1, name: operator")
    }

    func testFetchStatusWithBadPayloadThrowsDecodingError() async {
        let service = makeService { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, Data("nope".utf8))
        }

        do {
            _ = try await service.fetchStatus(from: Server(name: "Test", url: "http://example.com"))
            XCTFail("Expected decoding failure")
        } catch let error as NetworkService.NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    private func makeService(
        handler: @escaping @Sendable (URLRequest) throws -> (HTTPURLResponse, Data) = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, Data())
        }
    ) -> NetworkService {
        URLProtocolMock.handler = handler

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        return NetworkService(session: session)
    }
}

private final class URLProtocolMock: URLProtocol, @unchecked Sendable {
    static var handler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
