// ContentView.swift
import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var dataStore: BondDataStore
    @State private var showSetup = false
    
    var body: some View {
        Group {
            if dataStore.bondData.isConfigured {
                TrackingView()
            } else {
                SetupView()
            }
        }
        .onAppear {
            // Force refresh when app appears
            dataStore.objectWillChange.send()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BondDataStore())
}
