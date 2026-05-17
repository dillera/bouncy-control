import Foundation
import SwiftUI

@MainActor
final class ControlViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var displayTime: String = "30"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private let networkService: NetworkServicing

    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    func sendCommand(_ endpoint: String, to server: Server) async {
        await performRequest {
            try await networkService.sendCommand(to: server, endpoint: endpoint)
        }
    }
    
    func sendBroadcast(to server: Server) async {
        guard let time = Int(displayTime), time > 0 else {
            errorMessage = "Display time must be a valid number greater than 0"
            showAlert = true
            return
        }


        await performRequest {
            try await networkService.sendBroadcast(to: server, message: message, displayTime: time)
            message = ""
        }
    }

    private func performRequest(_ operation: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        showAlert = false

        do {
            try await operation()
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }

        isLoading = false
    }
}
