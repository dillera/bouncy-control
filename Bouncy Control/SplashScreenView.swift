//
//  SplashScreenView.swift
//  Bouncy Control
//
//  Created by Andrew Diller on 9/1/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView() // Transition to the main content view after 5 seconds
        } else {
            VStack {
                Image("StartupImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Adjust the size as needed
                    .padding()
                
                Text("Bouncy Control")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
            .onAppear {
                // Start a timer to switch to the main view after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
