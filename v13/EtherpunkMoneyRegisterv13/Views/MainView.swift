//
//  MainView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appContainer: LocalAppStateContainer
    @State var tabSelection: Tab = .accounts

    var body: some View {
        TabView(selection: $tabSelection) {
            AccountListView(tabSelection: $tabSelection)
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
                .tag(Tab.accounts)
            Text("Metadata")
                .tabItem {
                    Label("Metadata", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.metadata)
            Text("Reports")
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.reports)
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    MainView()
}
