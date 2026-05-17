//
//  ContentViewTests.swift
//  Bouncy Control Tests
//
//  Unit tests for ContentView logic
//

import XCTest
import SwiftUI
@testable import Bouncy_Control

final class ContentViewTests: XCTestCase {

    // MARK: - Server Management Tests

    func testServerCreation() {
        // Given
        let serverName = "Test Server"
        let serverURL = "http://localhost:8080"

        // When
        let server = Server(name: serverName, url: serverURL)

        // Then
        XCTAssertEqual(server.name, serverName)
        XCTAssertEqual(server.url, serverURL)
    }

    func testServerListAppending() {
        // Given
        var servers: [Server] = []
        let server1 = Server(name: "Server 1", url: "http://localhost:8080")
        let server2 = Server(name: "Server 2", url: "http://localhost:8081")

        // When
        servers.append(server1)
        servers.append(server2)

        // Then
        XCTAssertEqual(servers.count, 2)
        XCTAssertEqual(servers[0].name, "Server 1")
        XCTAssertEqual(servers[1].name, "Server 2")
    }

    func testServerDeletion() {
        // Given
        var servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081"),
            Server(name: "Server 3", url: "http://localhost:8082")
        ]
        let serverToDelete = servers[1]

        // When
        servers.removeAll { $0.id == serverToDelete.id }

        // Then
        XCTAssertEqual(servers.count, 2)
        XCTAssertFalse(servers.contains(where: { $0.id == serverToDelete.id }))
    }

    func testServerDeletionAtOffset() {
        // Given
        var servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081"),
            Server(name: "Server 3", url: "http://localhost:8082")
        ]
        let offsetToDelete = IndexSet(integer: 1)

        // When
        servers.remove(atOffsets: offsetToDelete)

        // Then
        XCTAssertEqual(servers.count, 2)
        XCTAssertEqual(servers[0].name, "Server 1")
        XCTAssertEqual(servers[1].name, "Server 3")
    }

    func testServerUpdate() {
        // Given
        var servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081")
        ]
        let serverToUpdate = servers[0]
        var updatedServer = serverToUpdate
        updatedServer.name = "Updated Server"
        updatedServer.url = "http://updated.com"

        // When
        if let index = servers.firstIndex(where: { $0.id == serverToUpdate.id }) {
            servers[index] = updatedServer
        }

        // Then
        XCTAssertEqual(servers[0].name, "Updated Server")
        XCTAssertEqual(servers[0].url, "http://updated.com")
        XCTAssertEqual(servers[0].id, serverToUpdate.id)
    }

    // MARK: - JSON Encoding/Decoding Tests

    func testServerArrayEncoding() throws {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081")
        ]

        // When
        let encoded = try JSONEncoder().encode(servers)

        // Then
        XCTAssertFalse(encoded.isEmpty)
    }

    func testServerArrayDecoding() throws {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081")
        ]
        let encoded = try JSONEncoder().encode(servers)

        // When
        let decoded = try JSONDecoder().decode([Server].self, from: encoded)

        // Then
        XCTAssertEqual(decoded.count, servers.count)
        XCTAssertEqual(decoded[0].id, servers[0].id)
        XCTAssertEqual(decoded[1].id, servers[1].id)
    }

    func testEmptyServerArrayEncoding() throws {
        // Given
        let servers: [Server] = []

        // When
        let encoded = try JSONEncoder().encode(servers)
        let decoded = try JSONDecoder().decode([Server].self, from: encoded)

        // Then
        XCTAssertTrue(decoded.isEmpty)
    }

    // MARK: - Input Validation Tests

    func testTrimmedServerName() {
        // Given
        let input = "  Test Server  "
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // Then
        XCTAssertEqual(trimmed, "Test Server")
    }

    func testTrimmedServerURL() {
        // Given
        let input = "  http://localhost:8080  "
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // Then
        XCTAssertEqual(trimmed, "http://localhost:8080")
    }

    func testEmptyNameValidation() {
        // Given
        let name = "   "
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        // Then
        XCTAssertTrue(trimmed.isEmpty)
    }

    func testEmptyURLValidation() {
        // Given
        let url = "   "
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines)

        // Then
        XCTAssertTrue(trimmed.isEmpty)
    }

    // MARK: - Server Finding Tests

    func testFindServerByID() {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081"),
            Server(name: "Server 3", url: "http://localhost:8082")
        ]
        let targetServer = servers[1]

        // When
        let foundIndex = servers.firstIndex(where: { $0.id == targetServer.id })

        // Then
        XCTAssertNotNil(foundIndex)
        XCTAssertEqual(foundIndex, 1)
    }

    func testFindNonExistentServer() {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081")
        ]
        let nonExistentID = UUID()

        // When
        let foundIndex = servers.firstIndex(where: { $0.id == nonExistentID })

        // Then
        XCTAssertNil(foundIndex)
    }

    // MARK: - Data Persistence Tests

    func testDataPersistenceFormat() throws {
        // Given
        let servers = [
            Server(name: "Server 1", url: "http://localhost:8080"),
            Server(name: "Server 2", url: "http://localhost:8081")
        ]

        // When
        let encoded = try JSONEncoder().encode(servers)

        // Then
        XCTAssertTrue(encoded.count > 0)

        // Verify can be decoded back
        let decoded = try JSONDecoder().decode([Server].self, from: encoded)
        XCTAssertEqual(decoded.count, servers.count)
    }

    // MARK: - Edge Cases

    func testMultipleServersWithSameName() {
        // Given
        let server1 = Server(name: "Test", url: "http://localhost:8080")
        let server2 = Server(name: "Test", url: "http://localhost:8081")
        let servers = [server1, server2]

        // Then - should be allowed, distinguished by ID
        XCTAssertEqual(servers.count, 2)
        XCTAssertNotEqual(servers[0].id, servers[1].id)
    }

    func testMultipleServersWithSameURL() {
        // Given
        let server1 = Server(name: "Server 1", url: "http://localhost:8080")
        let server2 = Server(name: "Server 2", url: "http://localhost:8080")
        let servers = [server1, server2]

        // Then - should be allowed, distinguished by ID
        XCTAssertEqual(servers.count, 2)
        XCTAssertNotEqual(servers[0].id, servers[1].id)
    }

    func testLargeServerList() {
        // Given
        var servers: [Server] = []

        // When - create 100 servers
        for i in 0..<100 {
            servers.append(Server(name: "Server \(i)", url: "http://localhost:\(8080 + i)"))
        }

        // Then
        XCTAssertEqual(servers.count, 100)

        // All IDs should be unique
        let uniqueIDs = Set(servers.map { $0.id })
        XCTAssertEqual(uniqueIDs.count, 100)
    }

    func testServerWithLongName() {
        // Given
        let longName = String(repeating: "A", count: 1000)
        let server = Server(name: longName, url: "http://localhost:8080")

        // Then
        XCTAssertEqual(server.name.count, 1000)
    }

    func testServerWithLongURL() {
        // Given
        let longURL = "http://localhost:8080/" + String(repeating: "path/", count: 100)
        let server = Server(name: "Test", url: longURL)

        // Then
        XCTAssertTrue(server.url.count > 500)
    }
}
