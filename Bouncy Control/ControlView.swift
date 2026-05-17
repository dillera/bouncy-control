import SwiftUI

struct ControlView: View {
    let server: Server
    @StateObject private var viewModel = ControlViewModel()

    private let buttonColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    struct CommandButtonStyle: ButtonStyle {
        var colors: [Color]

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: 58)
                .padding(.horizontal, 10)
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

            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        header

                        VStack(spacing: 12) {
                            LazyVGrid(columns: buttonColumns, spacing: 10) {
                                commandButton(
                                    title: "Add S1",
                                    subtitle: "Small"
                                ) {
                                    await viewModel.sendCommand("/add/1", to: server)
                                }

                                commandButton(
                                    title: "Add S2",
                                    subtitle: "Medium"
                                ) {
                                    await viewModel.sendCommand("/add/2", to: server)
                                }

                                commandButton(
                                    title: "Add S3",
                                    subtitle: "Wide"
                                ) {
                                    await viewModel.sendCommand("/add/3", to: server)
                                }

                                commandButton(
                                    title: "Add S4",
                                    subtitle: "Heavy"
                                ) {
                                    await viewModel.sendCommand("/add/4", to: server)
                                }

                                commandButton(
                                    title: "Add S5",
                                    subtitle: "Large"
                                ) {
                                    await viewModel.sendCommand("/add/5", to: server)
                                }

                                commandButton(
                                    title: "Reset",
                                    subtitle: "Clear all",
                                    colors: [Color(red: 1.0, green: 0.37, blue: 0.38), Color(red: 0.84, green: 0.13, blue: 0.18)]
                                ) {
                                    await viewModel.sendCommand("/reset", to: server)
                                }

                                commandButton(
                                    title: "Pause",
                                    subtitle: "Freeze toggle",
                                    colors: [Color(red: 1.0, green: 0.71, blue: 0.24), Color(red: 1.0, green: 0.49, blue: 0.12)]
                                ) {
                                    await viewModel.sendCommand("/freeze", to: server)
                                }

                                NavigationLink(destination: StatusView(server: server)) {
                                    buttonLabel(title: "Status", subtitle: "Live world")
                                }
                                .buttonStyle(
                                    CommandButtonStyle(
                                        colors: [Color(red: 0.27, green: 0.67, blue: 1.0), Color(red: 0.13, green: 0.34, blue: 0.94)]
                                    )
                                )
                            }

                            messageComposer
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: 430)
                    .padding(.horizontal, 16)
                    .padding(.top, max(geometry.safeAreaInsets.top, 12))
                    .padding(.bottom, 18)
                    .frame(maxWidth: .infinity)
                }
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bouncy Control")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(server.name)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.78))

            Text("Direct control for http://bouncy.diller.org/")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.58))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var messageComposer: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Broadcast")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primary.opacity(0.88))

            TextField("Message for the world", text: $viewModel.message)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            HStack(spacing: 10) {
                TextField("Secs", text: $viewModel.displayTime)
                    .textFieldStyle(.plain)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                Button(action: {
                    Task { await viewModel.sendBroadcast(to: server) }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(
                    CommandButtonStyle(
                        colors: [Color(red: 0.12, green: 0.76, blue: 0.52), Color(red: 0.06, green: 0.58, blue: 0.43)]
                    )
                )
            }
        }
    }

    private func commandButton(
        title: String,
        subtitle: String,
        colors: [Color] = [Color(red: 0.31, green: 0.66, blue: 1.0), Color(red: 0.16, green: 0.35, blue: 0.96)],
        action: @escaping @MainActor () async -> Void
    ) -> some View {
        Button(action: {
            Task { await action() }
        }) {
            buttonLabel(title: title, subtitle: subtitle)
        }
        .buttonStyle(CommandButtonStyle(colors: colors))
    }

    private func buttonLabel(title: String, subtitle: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(subtitle)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}
