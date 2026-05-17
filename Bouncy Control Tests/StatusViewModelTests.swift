import XCTest
@testable import Bouncy_Control

@MainActor
final class StatusViewModelTests: XCTestCase {
    func testRefreshLoadsStatusAndTimestamp() async {
        let service = MockStatusNetworkService()
        let viewModel = StatusViewModel(networkService: service, pollInterval: .seconds(60))

        await viewModel.refresh(server: Server(name: "Test", url: "http://example.com"))

        XCTAssertEqual(viewModel.status?.width, 40)
        XCTAssertNotNil(viewModel.lastUpdated)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testRefreshFailurePreservesErrorMessage() async {
        let service = MockStatusNetworkService()
        service.error = NetworkService.NetworkError.httpError(503)
        let viewModel = StatusViewModel(networkService: service, pollInterval: .seconds(60))

        await viewModel.refresh(server: Server(name: "Test", url: "http://example.com"))

        XCTAssertEqual(viewModel.errorMessage, "HTTP error: 503")
        XCTAssertNil(viewModel.status)
    }
}

@MainActor
private final class MockStatusNetworkService: NetworkServicing {
    var error: Error?

    func sendCommand(to server: Server, endpoint: String) async throws {}

    func sendBroadcast(to server: Server, message: String, displayTime: Int) async throws {}

    func fetchStatus(from server: Server) async throws -> BouncyWorldStatus {
        if let error {
            throw error
        }

        return BouncyWorldStatus(
            width: 40,
            height: 24,
            frozen: false,
            wrapping: true,
            bodyCounts: [BouncyBodyCount(size: 1, count: 3)],
            bodies: [],
            clients: []
        )
    }
}
