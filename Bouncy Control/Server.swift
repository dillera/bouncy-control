//
//  Server.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//

import Foundation

struct Server: Identifiable, Codable {
    var id = UUID()
    var name: String
    var url: String
}
