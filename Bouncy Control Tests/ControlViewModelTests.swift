import XCTest
@testable import Bouncy_Control

@MainActor
final class ControlViewModelTests: XCTestCase {
    func testInitialState() {
        let viewModel = ControlViewModel(networkService: MockNetworkService())

        XCTAssertEqual(viewModel.message, "")
        XCTAssertEqual(viewModel.displayTime, "30")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showAlert)
    }

    func testSendBroadcastWithInvalidDisplayTimeShowsValidationError() async {
        let viewModel = ControlViewModel(networkService: MockNetworkService())
        viewModel.message = "Hello"
        viewModel.displayTime = "abc"

        await viewModel.sendBroadcast(to: Server(name: "Test", url: "http://example.com"))

        XCTAssertEqual(viewModel.errorMessage, "Display time must be a valid number greater than 0")
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSendBroadcastSuccessClearsMessage() async {
        let service = MockNetworkService()
        let viewModel = ControlViewModel(networkService: service)
        let server = Server(name: "Test", url: "http://example.com")
        viewModel.message = "Broadcast"
        viewModel.displayTime = "30"

        await viewModel.sendBroadcast(to: server)

        XCTAssertEqual(service.lastBroadcastMessage, "Broadcast")
        XCTAssertEqual(service.lastBroadcastDisplayTime, 30)
        XCTAssertEqual(viewModel.message, "")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showAlert)
    }

    func testSendCommandFailureShowsAlert() async {
        let service = MockNetworkService()
        service.commandError = NetworkService.NetworkError.httpError(500)
        let viewModel = ControlViewModel(networkService: service)

        await viewModel.sendCommand("/reset", to: Server(name: "Test", url: "http://example.com"))

        XCTAssertEqual(service.lastCommandEndpoint, "/reset")
        XCTAssertEqual(viewModel.errorMessage, "HTTP error: 500")
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.isLoading)
    }
}

@MainActor
private final class MockNetworkService: NetworkServicing {
    var commandError: Error?
    var broadcastError: Error?
    var statusToReturn = BouncyWorldStatus(
        width: 40,
        height: 24,
        frozen: false,
        wrapping: false,
        bodyCounts: [],
        bodies: [],
        clients: []
    )

    private(set) var lastCommandEndpoint: String?
    private(set) var lastBroadcastMessage: String?
    private(set) var lastBroadcastDisplayTime: Int?

    func sendCommand(to server: Server, endpoint: String) async throws {
        lastCommandEndpoint = endpoint
        if let commandError {
            throw commandError
        }
    }

    func sendBroadcast(to server: Server, message: String, displayTime: Int) async throws {
        lastBroadcastMessage = message
        lastBroadcastDisplayTime = displayTime
        if let broadcastError {
            throw broadcastError
        }
    }

    func fetchStatus(from server: Server) async throws -> BouncyWorldStatus {
        statusToReturn
    }
}
