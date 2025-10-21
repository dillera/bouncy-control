//
//  ContentView.swift
//  BouncyControl
//
//  Created on 10/21/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BouncyControlViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Bouncy Control")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                // Connection Status
                HStack {
                    Circle()
                        .fill(viewModel.isConnected ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text(viewModel.isConnected ? "Connected" : "Disconnected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()
                    .padding(.horizontal)

                // World List
                if viewModel.isLoading {
                    ProgressView("Loading worlds...")
                        .padding()
                } else if viewModel.worlds.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "globe")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No worlds available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Pull to refresh")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.worlds) { world in
                            NavigationLink(destination: ControlPanelView(world: world, viewModel: viewModel)) {
                                WorldRowView(world: world)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()

                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // Refresh Button
                Button(action: {
                    viewModel.fetchWorlds()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh Worlds")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.fetchWorlds()
        }
    }
}

struct WorldRowView: View {
    let world: BouncyWorld

    var body: some View {
        HStack {
            Image(systemName: "globe")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(world.name)
                    .font(.headline)
                Text("ID: \(world.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Circle()
                .fill(world.isActive ? Color.green : Color.gray)
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
