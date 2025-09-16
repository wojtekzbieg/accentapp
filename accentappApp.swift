//
//  accentappApp.swift
//  accentapp
//
//  Created by Wojciech Zbieg on 29/08/2025.
//
import SwiftUI

@main
struct accentApp: App {
    @AppStorage("didOnboard") private var didOnboard: Bool = false

    var body: some Scene {
        WindowGroup {
            if didOnboard {
                MainView()
            } else {
                OnboardingView {
                    didOnboard = true
                }
            }
        }
    }
}

