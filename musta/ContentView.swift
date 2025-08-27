//
//  ContentView.swift
//  musta
//
//  Created by Jyle Vergara on 2025-08-27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var languageManager = LanguageManager()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            LanguageSelectionView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Language")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .environmentObject(languageManager)
    }
}

#Preview {
    ContentView()
}
