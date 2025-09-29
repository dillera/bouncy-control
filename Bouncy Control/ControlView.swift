import SwiftUI

struct ControlView: View {
    var server: Server
    
    // State variables for the new broadcast command
    @State private var message: String = ""
    @State private var displayTime: String = "30" // Default display time is 30 seconds
    @State private var showAlert = false
    @State private var alertMessage = ""

    struct RoundedButtonStyle: ButtonStyle {
        var backgroundColor: Color = Color.blue
        var foregroundColor: Color = Color.white

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Command buttons for Add Body Size and Reset World
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Button(action: { sendCommand("/add/1") }) {
                        Text("Add Body Size 1")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle())

                    Button(action: { sendCommand("/add/2") }) {
                        Text("Add Body Size 2")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle())
                }

                HStack(spacing: 10) {
                    Button(action: { sendCommand("/add/3") }) {
                        Text("Add Body Size 3")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle())

                    Button(action: { sendCommand("/add/4") }) {
                        Text("Add Body Size 4")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle())
                }

                HStack(spacing: 10) {
                    Button(action: { sendCommand("/add/5") }) {
                        Text("Add Body Size 5")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle())

                    Button(action: { sendCommand("/reset") }) {
                        Text("Reset World")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(RoundedButtonStyle(backgroundColor: Color.red))
                }
            }
            
            // Section for Increase Speed and Decrease Speed buttons with arrow emojis
            HStack(spacing: 20) {
                Button(action: { sendCommand("/speed/increase") }) {
                    HStack {
                        Text("Increase Speed")
                            .font(.headline)
                        Text("⬆️") // Up arrow emoji
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(RoundedButtonStyle())

                Button(action: { sendCommand("/speed/decrease") }) {
                    HStack {
                        Text("Decrease Speed")
                            .font(.headline)
                        Text("⬇️") // Down arrow emoji
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(RoundedButtonStyle())
            }

            // New section for the broadcast command
            VStack(alignment: .leading) {
                Text("Broadcast Message")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                TextField("Enter message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)

                TextField("Display Time (in seconds)", text: $displayTime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad) // Only allows numeric input
                    .padding(.bottom, 10)

                Button(action: {
                    sendBroadcastCommand()
                }) {
                    Text("Send Broadcast")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Control Panel")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to send regular commands to the server
    func sendCommand(_ endpoint: String) {
        print("Server URL: \(server.url)")
        print("Endpoint: \(endpoint)")
        
        // Ensure the base URL is properly formatted and construct the final URL
        guard server.url.hasPrefix("http://") || server.url.hasPrefix("https://"),
              let baseURL = URL(string: server.url) else {
            alertMessage = "Invalid server URL: \(server.url)"
            showAlert = true
            return
        }
        
        guard let finalURL = URL(string: endpoint, relativeTo: baseURL) else {
            alertMessage = "Failed to construct a valid URL."
            showAlert = true
            return
        }
        
        print("Final URL: \(finalURL.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error reaching server: \(error.localizedDescription)"
                    self.showAlert = true
                }
                print("Error sending command: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Command \(endpoint) sent successfully to \(server.url)")
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to send command \(endpoint) to \(server.url)"
                    self.showAlert = true
                }
            }
        }
        
        task.resume()
    }

    // Function to send the broadcast command to the server
    func sendBroadcastCommand() {
        // Ensure message and display time are valid
        guard !message.isEmpty else {
            alertMessage = "Message cannot be empty."
            showAlert = true
            return
        }
        
        guard let time = Int(displayTime), time > 0 else {
            alertMessage = "Display time must be a valid number greater than 0."
            showAlert = true
            return
        }
        
        // Construct the URL
        let formattedMessage = message.replacingOccurrences(of: " ", with: "_") // Replace spaces with underscores
        let endpoint = "/cmd/broadcast/ALL/\(time)/\(formattedMessage)"
        
        guard let baseURL = URL(string: server.url), let finalURL = URL(string: endpoint, relativeTo: baseURL) else {
            alertMessage = "Invalid server URL."
            showAlert = true
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error sending broadcast: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Broadcast sent successfully to \(server.url)")
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to send broadcast to server. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
                    self.showAlert = true
                }
            }
        }
        
        task.resume()
    }
}
