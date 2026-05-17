//
//  ServerTests.swift
//  Bouncy Control Tests
//
//  Unit tests for Server model
//

import XCTest
@testable import Bouncy_Control

final class ServerTests: XCTestCase {

    // MARK: - Initialization Tests

    func testServerInitialization() {
        // Given
        let name = "Test Server"
        let url = "http://localhost:8080"

        // When
        let server = Server(name: name, url: url)

        // Then
        XCTAssertEqual(server.name, name)
        XCTAssertEqual(server.url, url)
        XCTAssertNotNil(server.id)
    }

    func testServerHasUniqueIDs() {
        // Given
        let server1 = Server(name: "Server 1", url: "http://localhost:8080")
        let server2 = Server(name: "Server 2", url: "http://localhost:8081")

        // Then
        XCTAssertNotEqual(server1.id, server2.id)
    }

    // MARK: - Identifiable Conformance Tests

    func testServerIsIdentifiable() {
        // Given
        let server = Server(name: "Test", url: "http://localhost:8080")

        // When
        let id = server.id

        // Then
        XCTAssertNotNil(id)
    }

    // MARK: - Codable Conformance Tests

    func testServerEncodesToJSON() throws {
        // Given
        let server = Server(name: "Test Server", url: "http://localhost:8080")
        let encoder = JSONEncoder()

        // When
        let data = try encoder.encode(server)

        // Then
        XCTAssertFalse(data.isEmpty)

        // Verify JSON structure
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["name"] as? String, "Test Server")
        XCTAssertEqual(json?["url"] as? String, "http://localhost:8080")
        XCTAssertNotNil(json?["id"] as? String)
    }

    func testServerDecodesFromJSON() throws {
        // Given
        let id = UUID()
        let jsonString = """
        {
            "id": "\(id.uuidString)",
            "name": "Test Server",
            "url": "http://localhost:8080"
        }
        """
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        // When
        let server = try decoder.decode(Server.self, from: data)

        // Then
        XCTAssertEqual(server.id, id)
        XCTAssertEqual(server.name, "Test Server")
        XCTAssertEqual(server.url, "http://localhost:8080")
    }

    func testServerRoundTripEncoding() throws {
        // Given
        let originalServer = Server(name: "Test Server", url: "http://localhost:8080")
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        // When
        let data = try encoder.encode(originalServer)
        let decodedServer = try decoder.decode(Server.self, from: data)

        // Then
        XCTAssertEqual(decodedServer.id, originalServer.id)
        XCTAssertEqual(decodedServer.name, originalServer.name)
        XCTAssertEqual(decodedServer.url, originalServer.url)
    }

    func testServerArrayEncodingDecoding() throws {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081"),
            Server(name: "Server 3", url: "http://localhost:8082")
        ]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        // When
        let data = try encoder.encode(servers)
        let decodedServers = try decoder.decode([Server].self, from: data)

        // Then
        XCTAssertEqual(decodedServers.count, servers.count)
        for (index, server) in servers.enumerated() {
            XCTAssertEqual(decodedServers[index].id, server.id)
            XCTAssertEqual(decodedServers[index].name, server.name)
            XCTAssertEqual(decodedServers[index].url, server.url)
        }
    }

    // MARK: - Equatable Tests (via Identifiable)

    func testServerEquality() {
        // Given
        let id = UUID()
        var server1 = Server(name: "Server 1", url: "http://localhost:8080")
        var server2 = Server(name: "Server 2", url: "http://localhost:8081")

        // Set same ID
        server1.id = id
        server2.id = id

        // Then - servers with same ID are considered equal
        XCTAssertEqual(server1.id, server2.id)
    }

    func testServerInequality() {
        // Given
        let server1 = Server(name: "Server 1", url: "http://localhost:8080")
        let server2 = Server(name: "Server 1", url: "http://localhost:8080")

        // Then - even with same properties, different IDs mean different servers
        XCTAssertNotEqual(server1.id, server2.id)
    }

    // MARK: - Property Mutation Tests

    func testServerPropertiesAreMutable() {
        // Given
        var server = Server(name: "Original", url: "http://original.com")

        // When
        server.name = "Updated"
        server.url = "http://updated.com"

        // Then
        XCTAssertEqual(server.name, "Updated")
        XCTAssertEqual(server.url, "http://updated.com")
    }

    // MARK: - URL Validation Tests

    func testServerAcceptsHTTPURL() {
        // Given/When
        let server = Server(name: "HTTP Server", url: "http://example.com")

        // Then
        XCTAssertTrue(server.url.hasPrefix("http://"))
    }

    func testServerAcceptsHTTPSURL() {
        // Given/When
        let server = Server(name: "HTTPS Server", url: "https://example.com")

        // Then
        XCTAssertTrue(server.url.hasPrefix("https://"))
    }

    func testServerAcceptsLocalhost() {
        // Given/When
        let server = Server(name: "Local Server", url: "http://localhost:8080")

        // Then
        XCTAssertTrue(server.url.contains("localhost"))
    }

    func testServerAcceptsIPAddress() {
        // Given/When
        let server = Server(name: "IP Server", url: "http://192.168.1.1:8080")

        // Then
        XCTAssertTrue(server.url.contains("192.168.1.1"))
    }

    // MARK: - Edge Case Tests

    func testServerWithEmptyName() {
        // Given/When
        let server = Server(name: "", url: "http://localhost:8080")

        // Then
        XCTAssertEqual(server.name, "")
        XCTAssertFalse(server.name.isEmpty == false)
    }

    func testServerWithEmptyURL() {
        // Given/When
        let server = Server(name: "Test", url: "")

        // Then
        XCTAssertEqual(server.url, "")
    }

    func testServerWithWhitespaceInName() {
        // Given/When
        let server = Server(name: "  Test Server  ", url: "http://localhost:8080")

        // Then
        XCTAssertEqual(server.name, "  Test Server  ")
    }

    func testServerWithSpecialCharactersInName() {
        // Given/When
        let server = Server(name: "Test-Server_123!@#", url: "http://localhost:8080")

        // Then
        XCTAssertEqual(server.name, "Test-Server_123!@#")
    }
}
