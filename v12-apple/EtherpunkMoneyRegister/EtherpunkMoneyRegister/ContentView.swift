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
            TransactionListView()
                .tabItem {
                    Label("Transactions", systemImage: "banknote")
                }
            Text("Tab 2")
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
            Text("Tab 2")
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
            Text("Tab 2")
                .tabItem {
                    Label("Recurring", systemImage: "repeat")
                }
            Text("Tab 2")
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
