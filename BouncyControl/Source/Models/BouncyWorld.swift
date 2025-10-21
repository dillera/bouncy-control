//
//  BouncyWorld.swift
//  BouncyControl
//
//  Created on 10/21/2025.
//

import Foundation

/// Represents a Bouncy World that can be controlled through the app
struct BouncyWorld: Identifiable, Codable {
    let id: String
    let name: String
    var isActive: Bool
    var createdAt: Date?
    var lastModified: Date?
    var description: String?

    init(id: String, name: String, isActive: Bool, createdAt: Date? = nil, lastModified: Date? = nil, description: String? = nil) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.createdAt = createdAt
        self.lastModified = lastModified
        self.description = description
    }
}

/// Response model for world list API
struct WorldsResponse: Codable {
    let worlds: [BouncyWorld]
    let count: Int?
}

/// Response model for control actions
struct ControlResponse: Codable {
    let success: Bool
    let message: String
    let worldId: String?
}
