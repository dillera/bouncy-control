import SwiftUI

struct ServerRowView: View {
    let server: Server
    let onOpen: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onOpen) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(server.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(server.url)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .foregroundStyle(.blue)
                    .font(.title3)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Edit \(server.name)")
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .font(.title3)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Delete \(server.name)")
        }
        .padding(.vertical, 4)
    }
}
