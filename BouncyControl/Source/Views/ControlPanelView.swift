//
//  ControlPanelView.swift
//  BouncyControl
//
//  Created on 10/21/2025.
//

import SwiftUI

struct ControlPanelView: View {
    let world: BouncyWorld
    @ObservedObject var viewModel: BouncyControlViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // World Info Card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "globe")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text(world.name)
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    Divider()

                    HStack {
                        Text("ID:")
                            .fontWeight(.semibold)
                        Text(world.id)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        HStack {
                            Circle()
                                .fill(world.isActive ? Color.green : Color.gray)
                                .frame(width: 10, height: 10)
                            Text(world.isActive ? "Active" : "Inactive")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Control Buttons
                VStack(spacing: 15) {
                    Text("Controls")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Start/Stop Button
                    Button(action: {
                        if world.isActive {
                            stopWorld()
                        } else {
                            startWorld()
                        }
                    }) {
                        HStack {
                            Image(systemName: world.isActive ? "stop.circle.fill" : "play.circle.fill")
                            Text(world.isActive ? "Stop World" : "Start World")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(world.isActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Restart Button
                    Button(action: {
                        restartWorld()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise.circle.fill")
                            Text("Restart World")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Settings Button
                    Button(action: {
                        openSettings()
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("World Settings")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Stats Button
                    Button(action: {
                        viewStats()
                    }) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                            Text("View Statistics")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("Control Panel")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Control Panel"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Actions

    private func startWorld() {
        viewModel.startWorld(world) { success, message in
            alertMessage = message
            showingAlert = true
        }
    }

    private func stopWorld() {
        viewModel.stopWorld(world) { success, message in
            alertMessage = message
            showingAlert = true
        }
    }

    private func restartWorld() {
        viewModel.restartWorld(world) { success, message in
            alertMessage = message
            showingAlert = true
        }
    }

    private func openSettings() {
        alertMessage = "Settings panel coming soon!"
        showingAlert = true
    }

    private func viewStats() {
        alertMessage = "Statistics view coming soon!"
        showingAlert = true
    }
}

#Preview {
    NavigationView {
        ControlPanelView(
            world: BouncyWorld(id: "test-123", name: "Test World", isActive: true),
            viewModel: BouncyControlViewModel()
        )
    }
}
