//
//  ContentView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var serverName: String = ""
    @State private var serverURL: String = ""
    @AppStorage("serversData") private var serversData: Data = Data()
    @State private var servers: [Server] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the startup image
                Image("StartupImage") // Make sure this matches the name of your image set
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Adjust the size as needed
                    .padding()
                
                // Server input fields
                TextField("Server Name", text: $serverName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Server URL", text: $serverURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .padding()

                // Save button
                Button(action: {
                    saveServer()
                    hideKeyboard()
                }) {
                    Text("Save Server")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // List of saved servers
                List {
                    ForEach(servers) { server in
                        NavigationLink(destination: ControlView(server: server)) {
                            Text(server.name)
                        }
                    }
                    .onDelete(perform: deleteServer)
                }
                .padding()
            }
            .navigationTitle("Bouncy Control")
            .onAppear(perform: loadServers)
        }
    }
    
    // Save server details
    func saveServer() {
        guard !serverName.isEmpty, !serverURL.isEmpty else { return }
        let server = Server(name: serverName, url: serverURL)
        servers.append(server)
        saveServers()
        serverName = ""
        serverURL = ""
    }

    // Save servers to AppStorage
    func saveServers() {
        if let encoded = try? JSONEncoder().encode(servers) {
            serversData = encoded
        }
    }

    // Load servers from AppStorage
    func loadServers() {
        if let decoded = try? JSONDecoder().decode([Server].self, from: serversData) {
            servers = decoded
        }
    }

    // Delete a server
    func deleteServer(at offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
        saveServers()
    }
    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
