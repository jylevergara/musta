//
//  mustaApp.swift
//  musta
//
//  Created by Jyle Vergara on 2025-08-27.
//

import SwiftUI
import UserNotifications

@main
struct mustaApp: App {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    checkFirstLaunchAndRequestPermission()
                }
        }
    }
    
    private func checkFirstLaunchAndRequestPermission() {
        let userDefaults = UserDefaults.standard
        let hasLaunchedBefore = userDefaults.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            // This is the first launch
            userDefaults.set(true, forKey: "hasLaunchedBefore")
            
            // Request notification permission after a short delay to ensure the app is fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                notificationManager.requestPermission()
            }
        }
    }
}
