//
//  ContentView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var serverName: String = ""
    @State private var serverURL: String = ""
    @AppStorage("serversData") private var serversData: Data = Data()
    @State private var servers: [Server] = []
    @State private var selectedServer: Server? = nil // State to manage selected server for editing
    @State private var showEditView = false // State to show/hide the edit view
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the startup image
                Image("AppIcon") // Ensure this matches the name of your image set
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
                    .autocapitalization(UITextAutocapitalizationType.none) // Use explicit enum type
                    .keyboardType(UIKeyboardType.URL) // Use explicit enum type
                    .padding()

                // Save button
                Button(action: {
                    saveServer()
                    hideKeyboard() // Dismiss keyboard when saving
                }) {
                    Text("Save Server")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // List of saved servers with edit and delete icons
                List {
                    ForEach(servers) { server in
                        HStack {
                            // Wrap the server name in a NavigationLink
                            NavigationLink(destination: ControlView(server: server)) {
                                Text(server.name)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                selectedServer = server
                                showEditView.toggle()
                            }) {
                                Image(systemName: "pencil") // Edit icon
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Ensure button does not take full width

                            Button(action: {
                                deleteServer(server)
                            }) {
                                Image(systemName: "trash") // Delete icon
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Ensure button does not take full width
                        }
                    }
                    .onDelete(perform: deleteServer)
                }
                .padding()
            }
            .navigationTitle("Bouncy Control")
            .onAppear(perform: loadServers)
            .sheet(item: $selectedServer) { server in
                EditServerView(server: server) { updatedServer in
                    updateServer(updatedServer)
                    showEditView = false
                }
            }
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

    // Update server details
    func updateServer(_ updatedServer: Server) {
        if let index = servers.firstIndex(where: { $0.id == updatedServer.id }) {
            servers[index] = updatedServer
            saveServers()
        }
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
    func deleteServer(_ server: Server) {
        servers.removeAll { $0.id == server.id }
        saveServers()
    }

    // Delete server using List's built-in delete action
    func deleteServer(at offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
        saveServers()
    }

    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
