//
//  EditServerView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/4/24.
//

import SwiftUI

struct EditServerView: View {
    @State private var serverName: String
    @State private var serverURL: String
    var server: Server
    var onSave: (Server) -> Void
    
    // Environment variable to manage the presentation mode
    @Environment(\.dismiss) private var dismiss

    init(server: Server, onSave: @escaping (Server) -> Void) {
        self.server = server
        self.onSave = onSave
        _serverName = State(initialValue: server.name)
        _serverURL = State(initialValue: server.url)
    }
    
    var body: some View {
        VStack {
            TextField("Server Name", text: $serverName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Server URL", text: $serverURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .padding()

            Button(action: {
                saveChanges()
                dismiss()
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Edit Server")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedServer = server
        updatedServer.name = serverName
        updatedServer.url = serverURL
        onSave(updatedServer)
    }
}

struct EditServerView_Previews: PreviewProvider {
    static var previews: some View {
        EditServerView(server: Server(name: "Test Server", url: "http://192.168.251.100:8081")) { _ in }
    }
}
