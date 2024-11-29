//
//  ContentView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/15/24.
//

import SwiftData
import SwiftUI

struct ContentViewZ: View {
    @AppStorage("customizedTabView") var customizedTabView: TabViewCustomization
    @State private var selectedTab: MenuOptionsEnum = .accounts

    var body: some View {
        NavigationStack {
            TabView() {
                Tab(
                    "Dashboard",
                    systemImage: "paperplane"
                ) {
                    Text("Test")
                }

                Tab("Accounts", systemImage: "paperplane")
                {
                    Text("Test")
                }
            }
            .tabViewStyle(.grouped)
        }
    }

//        .searchable(text: $searchText)
//
//    }
}

#Preview {
    ContentViewZ()
    // .modelContainer(for: Item.self, inMemory: true)
}
