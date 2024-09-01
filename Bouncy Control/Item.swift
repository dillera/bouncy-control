//
//  Item.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
