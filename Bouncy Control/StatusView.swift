import SwiftUI

struct StatusView: View {
    let server: Server
    @StateObject private var viewModel = StatusViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let status = viewModel.status {
                    summarySection(status)
                    worldMapSection(status)
                    bodyCountsSection(status)
                    bodiesSection(status)
                    clientsSection(status)
                } else if viewModel.isLoading {
                    ProgressView("Loading world status...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 80)
                } else {
                    ContentUnavailableView(
                        "No World Status",
                        systemImage: "waveform.path.ecg",
                        description: Text(viewModel.errorMessage ?? "Unable to load status from \(server.name).")
                    )
                    .padding(.top, 80)
                }
            }
            .padding()
        }
        .navigationTitle("World Status")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.refresh(server: server)
        }
        .task {
            viewModel.startPolling(server: server)
        }
        .onDisappear {
            viewModel.stopPolling()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.refresh(server: server)
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel("Refresh world status")
            }
        }
        .alert("Status Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }

    private func summarySection(_ status: BouncyWorldStatus) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(server.name)
                .font(.title2.weight(.semibold))

            HStack(spacing: 12) {
                statusPill(title: "Bodies", value: "\(status.totalBodies)")
                statusPill(title: "Frozen", value: status.frozen ? "Yes" : "No")
                statusPill(title: "Wrapping", value: status.wrapping ? "On" : "Off")
                statusPill(title: "Clients", value: "\(status.clients.count)")
            }

            Text("World size: \(Int(status.width)) x \(Int(status.height))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let lastUpdated = viewModel.lastUpdated {
                Text("Last updated \(lastUpdated.formatted(date: .omitted, time: .standard))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func worldMapSection(_ status: BouncyWorldStatus) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("World Map")
                .font(.headline)

            WorldMapView(status: status)
                .frame(maxWidth: .infinity)
                .aspectRatio(status.width / max(status.height, 1), contentMode: .fit)
        }
    }

    private func bodyCountsSection(_ status: BouncyWorldStatus) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Body Counts")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
                ForEach(status.bodyCounts.sorted(by: { $0.size < $1.size })) { item in
                    VStack(spacing: 4) {
                        Text("Size \(item.size)")
                            .font(.subheadline.weight(.medium))
                        Text("\(item.count)")
                            .font(.title3.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private func bodiesSection(_ status: BouncyWorldStatus) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bodies")
                .font(.headline)

            ForEach(status.bodies) { body in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Body \(body.id)")
                        .font(.subheadline.weight(.semibold))
                    Text("Radius \(body.radius.formatted(.number.precision(.fractionLength(1...2))))  Mass \(body.mass.formatted(.number.precision(.fractionLength(1...2))))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Position \(vectorString(body.position))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Velocity \(vectorString(body.velocity))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    private func clientsSection(_ status: BouncyWorldStatus) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Clients")
                .font(.headline)

            if status.clients.isEmpty {
                Text("No connected clients")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(status.clients.enumerated()), id: \.offset) { index, client in
                    Text("Client \(index + 1): \(client.description)")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private func statusPill(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func vectorString(_ vector: BouncyVector) -> String {
        "(\(vector.x.formatted(.number.precision(.fractionLength(1...2)))), \(vector.y.formatted(.number.precision(.fractionLength(1...2)))))"
    }
}

private struct WorldMapView: View {
    let status: BouncyWorldStatus

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.18), Color.cyan.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.blue.opacity(0.35), lineWidth: 1)

                ForEach(status.bodies) { body in
                    Circle()
                        .fill(bodyColor(body))
                        .frame(
                            width: bodyDiameter(body, in: geometry.size),
                            height: bodyDiameter(body, in: geometry.size)
                        )
                        .overlay {
                            Text("\(body.id)")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        .position(bodyPosition(body, in: geometry.size))
                }
            }
        }
    }

    private func bodyDiameter(_ body: BouncyBody, in size: CGSize) -> CGFloat {
        let scaled = (body.radius * 2 / max(status.width, 1)) * size.width
        return CGFloat(max(12, min(scaled, size.width * 0.2)))
    }

    private func bodyPosition(_ body: BouncyBody, in size: CGSize) -> CGPoint {
        let x = CGFloat(body.position.x / max(status.width, 1)) * size.width
        let y = size.height - (CGFloat(body.position.y / max(status.height, 1)) * size.height)
        return CGPoint(x: min(max(x, 0), size.width), y: min(max(y, 0), size.height))
    }

    private func bodyColor(_ body: BouncyBody) -> Color {
        let hue = Double(body.id % 10) / 10.0
        return Color(hue: hue, saturation: 0.75, brightness: 0.9)
    }
}
