//
//  BondTrackerApp.swift
//  BondTracker
//
//  Created by Teng Jun Siong on 12/11/2025.
//

import SwiftUI

@main
struct BondTrackerApp: App {
    @StateObject private var dataStore = BondDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
