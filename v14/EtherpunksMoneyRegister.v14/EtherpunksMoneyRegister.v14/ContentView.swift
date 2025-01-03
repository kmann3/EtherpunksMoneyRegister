//
//  ContentView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/15/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            TabView(selection: $pathStore.selectedTab) {
                Tab(
                    MenuOptionsEnum.dashboard.title,
                    systemImage: MenuOptionsEnum.dashboard.iconName,
                    value: MenuOptionsEnum.dashboard
                ) {
                    MenuOptionsEnum.dashboard.action
                }
                .customizationID(MenuOptionsEnum.dashboard.tabId)


                Tab(
                    MenuOptionsEnum.accounts.title,
                    systemImage: MenuOptionsEnum.accounts.iconName,
                    value: MenuOptionsEnum.accounts
                ) {
                    MenuOptionsEnum.accounts.action
                }
                .customizationID(MenuOptionsEnum.accounts.tabId)

                Tab(
                    MenuOptionsEnum.recurringTransactions.title,
                    systemImage: MenuOptionsEnum.recurringTransactions.iconName,
                    value: MenuOptionsEnum.recurringTransactions
                ) {
                    MenuOptionsEnum.recurringTransactions.action
                }
                .customizationID(MenuOptionsEnum.recurringTransactions.tabId)

                Tab(
                    MenuOptionsEnum.tags.title,
                    systemImage: MenuOptionsEnum.tags.iconName,
                    value: MenuOptionsEnum.tags
                ) {
                    TagsView(navPath: pathStore)
                }
                .customizationID(MenuOptionsEnum.tags.tabId)

                Tab(
                    MenuOptionsEnum.reports.title,
                    systemImage: MenuOptionsEnum.reports.iconName,
                    value: MenuOptionsEnum.reports
                ) {
                    MenuOptionsEnum.reports.action
                }
                .customizationID(MenuOptionsEnum.reports.tabId)

                Tab(
                    MenuOptionsEnum.search.title,
                    systemImage: MenuOptionsEnum.search.iconName,
                    value: MenuOptionsEnum
                        .search
                ) {
                    MenuOptionsEnum.search.action
                }
                .customizationID(MenuOptionsEnum.search.tabId)

                Tab(
                    MenuOptionsEnum.settings.title,
                    systemImage: MenuOptionsEnum.settings.iconName,
                    value: MenuOptionsEnum.settings
                ) {
                    MenuOptionsEnum.settings.action
                }
                .customizationID(MenuOptionsEnum.settings.tabId)

                TabSection {
                    // This is where we'd do a foreach loop listing all the accounts
                    Tab(
                        "Accounts 1",
                        systemImage: MenuOptionsEnum.accounts.iconName,
                        value: MenuOptionsEnum
                            .accounts
                    ) {
                        Text("Hello, World!")
                    }
                    .customizationID("\(MenuOptionsEnum.accounts.tabId).account1")
                } header: {
                    Label("Accounts", systemImage: MenuOptionsEnum.accounts.iconName)
                }
                .sectionActions {
                    Button("New Account", systemImage: "plus") {
                        print("New account method here")
                    }
                }

#if os(iOS)
                Tab(value: .search, role: .search) {
                    MenuOptionsEnum.search.action
                }
#endif
            }
            .tabViewStyle(.sidebarAdaptable)
        }
#if os(macOS)
        .frame(minWidth: 850, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
#endif
    }

//        .searchable(text: $searchText)
//
//    }
}

#Preview {
    let p = Previewer()
    ContentView()
        .modelContainer(p.container)
#if os(macOS)
        .frame(width: 900, height: 500)
#endif
    // .modelContainer(for: Item.self, inMemory: true)
}
