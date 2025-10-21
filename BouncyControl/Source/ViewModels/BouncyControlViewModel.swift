//
//  BouncyControlViewModel.swift
//  BouncyControl
//
//  Created on 10/21/2025.
//

import Foundation
import Combine

/// Main ViewModel for controlling Bouncy Worlds
/// Handles business logic and communication with the network service
@MainActor
class BouncyControlViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var worlds: [BouncyWorld] = []
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
        setupNetworkMonitoring()
    }

    // MARK: - Public Methods

    /// Fetches the list of available worlds from the server
    func fetchWorlds() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedWorlds = try await networkService.fetchWorlds()
                await MainActor.run {
                    self.worlds = fetchedWorlds
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch worlds: \(error.localizedDescription)"
                    self.isLoading = false
                    // Load mock data for demo purposes
                    self.loadMockData()
                }
            }
        }
    }

    /// Starts a specific world
    func startWorld(_ world: BouncyWorld, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                let response = try await networkService.startWorld(worldId: world.id)
                await MainActor.run {
                    if response.success {
                        if let index = worlds.firstIndex(where: { $0.id == world.id }) {
                            worlds[index].isActive = true
                        }
                    }
                    completion(response.success, response.message)
                }
            } catch {
                await MainActor.run {
                    completion(false, "Failed to start world: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Stops a specific world
    func stopWorld(_ world: BouncyWorld, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                let response = try await networkService.stopWorld(worldId: world.id)
                await MainActor.run {
                    if response.success {
                        if let index = worlds.firstIndex(where: { $0.id == world.id }) {
                            worlds[index].isActive = false
                        }
                    }
                    completion(response.success, response.message)
                }
            } catch {
                await MainActor.run {
                    completion(false, "Failed to stop world: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Restarts a specific world
    func restartWorld(_ world: BouncyWorld, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                let response = try await networkService.restartWorld(worldId: world.id)
                await MainActor.run {
                    if response.success {
                        if let index = worlds.firstIndex(where: { $0.id == world.id }) {
                            worlds[index].isActive = true
                        }
                    }
                    completion(response.success, response.message)
                }
            } catch {
                await MainActor.run {
                    completion(false, "Failed to restart world: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Private Methods

    private func setupNetworkMonitoring() {
        // Monitor network connectivity
        // This is a simplified version - you might want to use NWPathMonitor for real implementation
        isConnected = true
    }

    /// Loads mock data for demonstration purposes
    private func loadMockData() {
        worlds = [
            BouncyWorld(
                id: "world-001",
                name: "Gravity Garden",
                isActive: true,
                createdAt: Date(),
                description: "A world with dynamic gravity physics"
            ),
            BouncyWorld(
                id: "world-002",
                name: "Elastic Empire",
                isActive: false,
                createdAt: Date().addingTimeInterval(-86400),
                description: "Everything bounces here!"
            ),
            BouncyWorld(
                id: "world-003",
                name: "Spring Valley",
                isActive: true,
                createdAt: Date().addingTimeInterval(-172800),
                description: "A valley full of springs and trampolines"
            )
        ]
    }
}
