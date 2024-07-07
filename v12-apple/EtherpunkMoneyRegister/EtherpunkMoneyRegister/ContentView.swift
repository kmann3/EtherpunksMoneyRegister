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
            InternalView()
                .tabItem {
                    Label("Internal", systemImage: "list.bullet.clipboard")
                }
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
            SettingsView()
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
