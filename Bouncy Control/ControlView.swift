import SwiftUI

struct ControlView: View {
    let server: Server
    @StateObject private var viewModel = ControlViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    struct CommandButtonStyle: ButtonStyle {
        var colors: [Color]
        var minHeight: CGFloat

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .padding(.horizontal, 8)
                .background(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(
                    color: colors.last?.opacity(0.28) ?? .black.opacity(0.15),
                    radius: configuration.isPressed ? 4 : 10,
                    y: configuration.isPressed ? 2 : 6
                )
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let metrics = layoutMetrics(for: geometry)
            let panelHeight = max(
                0,
                geometry.size.height - max(geometry.safeAreaInsets.top, 8) - max(geometry.safeAreaInsets.bottom, 12)
            )

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.16),
                        Color(red: 0.11, green: 0.17, blue: 0.29),
                        Color(red: 0.93, green: 0.95, blue: 0.99)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    VStack(spacing: metrics.sectionSpacing) {
                        header(metrics: metrics)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: metrics.headerHeight, alignment: .topLeading)

                        LazyVGrid(columns: buttonColumns(for: metrics), spacing: metrics.gridSpacing) {
                            commandButton(
                                title: "Add S1",
                                subtitle: "Small",
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/add/1", to: server)
                            }

                            commandButton(
                                title: "Add S2",
                                subtitle: "Medium",
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/add/2", to: server)
                            }

                            commandButton(
                                title: "Add S3",
                                subtitle: "Wide",
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/add/3", to: server)
                            }

                            commandButton(
                                title: "Add S4",
                                subtitle: "Heavy",
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/add/4", to: server)
                            }

                            commandButton(
                                title: "Add S5",
                                subtitle: "Large",
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/add/5", to: server)
                            }

                            commandButton(
                                title: "Reset",
                                subtitle: "Clear all",
                                colors: [Color(red: 1.0, green: 0.37, blue: 0.38), Color(red: 0.84, green: 0.13, blue: 0.18)],
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/reset", to: server)
                            }

                            commandButton(
                                title: "Pause",
                                subtitle: "Freeze toggle",
                                colors: [Color(red: 1.0, green: 0.71, blue: 0.24), Color(red: 1.0, green: 0.49, blue: 0.12)],
                                metrics: metrics
                            ) {
                                await viewModel.sendCommand("/freeze", to: server)
                            }

                            NavigationLink(destination: StatusView(server: server)) {
                                buttonLabel(title: "Status", subtitle: "Live world", metrics: metrics)
                            }
                            .buttonStyle(
                                CommandButtonStyle(
                                    colors: [Color(red: 0.27, green: 0.67, blue: 1.0), Color(red: 0.13, green: 0.34, blue: 0.94)],
                                    minHeight: metrics.buttonHeight
                                )
                            )
                        }
                        .frame(height: metrics.gridHeight, alignment: .top)

                        Spacer(minLength: 0)

                        messageComposer(metrics: metrics)
                            .frame(height: metrics.composerHeight, alignment: .bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(metrics.innerPanelPadding)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: metrics.panelCornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: metrics.panelCornerRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .frame(height: panelHeight, alignment: .top)
                }
                .padding(.horizontal, metrics.horizontalPadding)
                .padding(.top, max(geometry.safeAreaInsets.top, 8))
                .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                .frame(maxWidth: contentMaxWidth(for: geometry.size.width))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.22))
            }
        }
    }

    private func header(metrics: LayoutMetrics) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bouncy Control")
                .font(.system(size: metrics.titleSize, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(server.name)
                .font(.system(size: metrics.subtitleSize, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.78))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("Direct control for http://bouncy.diller.org/")
                .font(.system(size: metrics.captionSize, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.58))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }

    private func messageComposer(metrics: LayoutMetrics) -> some View {
        VStack(alignment: .leading, spacing: metrics.composerSpacing) {
            Text("Broadcast")
                .font(.system(size: metrics.broadcastLabelSize, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primary.opacity(0.88))

            TextField("Message for the world", text: $viewModel.message)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .frame(height: metrics.fieldHeight)
                .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            HStack(spacing: metrics.gridSpacing) {
                TextField("Secs", text: $viewModel.displayTime)
                    .textFieldStyle(.plain)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 14)
                    .frame(height: metrics.fieldHeight)
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                Button(action: {
                    Task { await viewModel.sendBroadcast(to: server) }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: metrics.fieldHeight)
                }
                .buttonStyle(
                    CommandButtonStyle(
                        colors: [Color(red: 0.12, green: 0.76, blue: 0.52), Color(red: 0.06, green: 0.58, blue: 0.43)],
                        minHeight: metrics.fieldHeight
                    )
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    private func commandButton(
        title: String,
        subtitle: String,
        colors: [Color] = [Color(red: 0.31, green: 0.66, blue: 1.0), Color(red: 0.16, green: 0.35, blue: 0.96)],
        metrics: LayoutMetrics,
        action: @escaping @MainActor () async -> Void
    ) -> some View {
        Button(action: {
            Task { await action() }
        }) {
            buttonLabel(title: title, subtitle: subtitle, metrics: metrics)
        }
        .buttonStyle(CommandButtonStyle(colors: colors, minHeight: metrics.buttonHeight))
    }

    private func buttonLabel(title: String, subtitle: String, metrics: LayoutMetrics) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: metrics.buttonTitleSize, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(subtitle)
                .font(.system(size: metrics.buttonSubtitleSize, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }

    private func contentMaxWidth(for availableWidth: CGFloat) -> CGFloat {
        if horizontalSizeClass == .regular {
            return min(availableWidth - 32, 560)
        }

        return max(0, availableWidth - 32)
    }

    private func buttonColumns(for metrics: LayoutMetrics) -> [GridItem] {
        [
            GridItem(.flexible(), spacing: metrics.gridSpacing),
            GridItem(.flexible(), spacing: metrics.gridSpacing)
        ]
    }

    private func layoutMetrics(for geometry: GeometryProxy) -> LayoutMetrics {
        let availableHeight = geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom
        let compactHeight = availableHeight < 760
        let horizontalPadding: CGFloat = 16
        let panelCornerRadius: CGFloat = compactHeight ? 24 : 28
        let innerPanelPadding: CGFloat = compactHeight ? 14 : 16
        let sectionSpacing: CGFloat = compactHeight ? 10 : 12
        let gridSpacing: CGFloat = compactHeight ? 8 : 10
        let headerHeight = compactHeight ? 86.0 : 102.0
        let composerHeight = compactHeight ? 112.0 : 124.0
        let safeTop = max(geometry.safeAreaInsets.top, 8)
        let safeBottom = max(geometry.safeAreaInsets.bottom, 12)
        let availablePanelHeight = max(
            300,
            availableHeight - safeTop - safeBottom
        )
        let gridHeight = max(
            220,
            availablePanelHeight - (innerPanelPadding * 2) - headerHeight - composerHeight - (sectionSpacing * 2)
        )
        let buttonHeight = (gridHeight - (gridSpacing * 3)) / 4

        return LayoutMetrics(
            sectionSpacing: sectionSpacing,
            gridSpacing: gridSpacing,
            horizontalPadding: horizontalPadding,
            innerPanelPadding: innerPanelPadding,
            panelCornerRadius: panelCornerRadius,
            headerHeight: headerHeight,
            gridHeight: gridHeight,
            composerHeight: composerHeight,
            titleSize: compactHeight ? 22 : 26,
            subtitleSize: compactHeight ? 14 : 16,
            captionSize: compactHeight ? 11 : 12,
            buttonTitleSize: compactHeight ? 16 : 18,
            buttonSubtitleSize: compactHeight ? 10 : 11,
            buttonHeight: buttonHeight,
            broadcastLabelSize: compactHeight ? 14 : 15,
            composerSpacing: compactHeight ? 8 : 10,
            fieldHeight: compactHeight ? 44 : 48
        )
    }
}

private struct LayoutMetrics {
    let sectionSpacing: CGFloat
    let gridSpacing: CGFloat
    let horizontalPadding: CGFloat
    let innerPanelPadding: CGFloat
    let panelCornerRadius: CGFloat
    let headerHeight: CGFloat
    let gridHeight: CGFloat
    let composerHeight: CGFloat
    let titleSize: CGFloat
    let subtitleSize: CGFloat
    let captionSize: CGFloat
    let buttonTitleSize: CGFloat
    let buttonSubtitleSize: CGFloat
    let buttonHeight: CGFloat
    let broadcastLabelSize: CGFloat
    let composerSpacing: CGFloat
    let fieldHeight: CGFloat
}
