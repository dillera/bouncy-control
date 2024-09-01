//
//  ControlView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//

import SwiftUI

// Custom Button Style
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

import SwiftUI

struct ControlView: View {
    var server: Server
    
    var body: some View {
        VStack(spacing: 20) {
            // Grid for "Add Body Size" buttons and "Reset World"
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

            // Section for "Increase Speed" and "Decrease Speed" buttons with arrow emojis
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
        }
        .padding()
        .navigationTitle("Control Panel")
    }
    
    // Function to send command to server
    func sendCommand(_ endpoint: String) {
        print("Server URL: \(server.url)")
        print("Endpoint: \(endpoint)")
        
        // Ensure the base URL is properly formatted and construct the final URL
        guard server.url.hasPrefix("http://") || server.url.hasPrefix("https://"),
              let baseURL = URL(string: server.url) else {
            print("Invalid base URL: \(server.url)")
            return
        }
        
        guard let finalURL = URL(string: endpoint, relativeTo: baseURL) else {
            print("Invalid final URL: \(baseURL)\(endpoint)")
            return
        }
        
        print("Final URL: \(finalURL.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error sending command: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Command \(endpoint) sent successfully to \(server.url)")
            } else {
                print("Failed to send command \(endpoint) to \(server.url)")
            }
        }
        
        task.resume()
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(server: Server(name: "Test Server", url: "http://192.168.251.100:8081"))
    }
}
