import Foundation

@MainActor
final class StatusViewModel: ObservableObject {
    @Published private(set) var status: BouncyWorldStatus?
    @Published private(set) var isLoading = false
    @Published private(set) var lastUpdated: Date?
    @Published var errorMessage: String?

    private let networkService: NetworkServicing
    private let pollInterval: Duration
    private var pollingTask: Task<Void, Never>?

    init(networkService: NetworkServicing = NetworkService(), pollInterval: Duration = .seconds(2)) {
        self.networkService = networkService
        self.pollInterval = pollInterval
    }

    deinit {
        pollingTask?.cancel()
    }

    func startPolling(server: Server) {
        stopPolling()

        pollingTask = Task { [weak self] in
            guard let self else { return }

            await refresh(server: server)

            while !Task.isCancelled {
                try? await Task.sleep(for: pollInterval)
                guard !Task.isCancelled else { break }
                await refresh(server: server, showLoading: false)
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func refresh(server: Server, showLoading: Bool = true) async {
        if showLoading {
            isLoading = true
        }

        do {
            status = try await networkService.fetchStatus(from: server)
            lastUpdated = Date()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }

        if showLoading {
            isLoading = false
        }
    }
}
