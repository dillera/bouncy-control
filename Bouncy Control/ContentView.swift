//
//  ContentView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//
import SwiftUI

struct ContentView: View {
    private let server = Server(
        name: "Diller Bouncy World",
        url: "http://bouncy.diller.org/"
    )
    
    var body: some View {
        NavigationStack {
            ControlView(server: server)
        }
    }
}
