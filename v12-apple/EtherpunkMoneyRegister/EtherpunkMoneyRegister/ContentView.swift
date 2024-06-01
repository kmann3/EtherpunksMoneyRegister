//
//  ContentView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct ContentView: View {
       
    var body: some View {
        TabView {
            AccountListView()
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
            Text("List of tags. Ability to create, delete, and lookup related transactions")
            // Should this just be in settings?
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
            Text("CRUD recurring transactions and show history")
                .tabItem {
                    Label("Recurring", systemImage: "repeat")
                }
            Text("Useful reports?")
            // Generate a list based off certain tags
            // Export a list of tax documents for itemizations
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
