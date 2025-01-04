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
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.dashboard.tabId)

                Tab(
                    MenuOptionsEnum.accounts.title,
                    systemImage: MenuOptionsEnum.accounts.iconName,
                    value: MenuOptionsEnum.accounts
                ) {
                    MenuOptionsEnum.accounts.action
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.accounts.tabId)

                Tab(
                    MenuOptionsEnum.recurringTransactions.title,
                    systemImage: MenuOptionsEnum.recurringTransactions.iconName,
                    value: MenuOptionsEnum.recurringTransactions
                ) {
                    MenuOptionsEnum.recurringTransactions.action
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.recurringTransactions.tabId)

                Tab(
                    MenuOptionsEnum.tags.title,
                    systemImage: MenuOptionsEnum.tags.iconName,
                    value: MenuOptionsEnum.tags
                ) {
                    TagsView()
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.tags.tabId)

                Tab(
                    MenuOptionsEnum.reports.title,
                    systemImage: MenuOptionsEnum.reports.iconName,
                    value: MenuOptionsEnum.reports
                ) {
                    MenuOptionsEnum.reports.action
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.reports.tabId)

                Tab(
                    MenuOptionsEnum.search.title,
                    systemImage: MenuOptionsEnum.search.iconName,
                    value: MenuOptionsEnum
                        .search
                ) {
                    MenuOptionsEnum.search.action
                        .environment(pathStore)
                }
                .customizationID(MenuOptionsEnum.search.tabId)

                Tab(
                    MenuOptionsEnum.settings.title,
                    systemImage: MenuOptionsEnum.settings.iconName,
                    value: MenuOptionsEnum.settings
                ) {
                    MenuOptionsEnum.settings.action
                        .environment(pathStore)
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
            .navigationDestination(for: PathStore.Route.self) { route in
                switch route {
                case .account_Create: Text("TBI")
                case .account_Details(let account):
                    AccountDetailsView(account: account)
                        .environment(pathStore)
                case .account_Edit: Text("TBI")
                case .account_List:
                    AccountsView()
                        .environment(pathStore)

                case .dashboard:
                    DashboardView()
                        .environment(pathStore)

                case .recurringGroup_Create: Text("TBI")
                case .recurringGroup_Details: Text("TBI")
                case .recurringGroup_Edit: Text("TBI")
                case .recurringGroup_List: Text("TBI")

                case .recurringTransaction_Create: Text("TBI")
                case .recurringTransaction_Details: Text("TBI")
                case .recurringTransaction_Edit: Text("TBI")
                case .recurringTransaction_List: Text("TBI")

                case .report_Tax: Text("TBI")

                case .tag_Create:
                    TagEditor(tag: TransactionTag(name: ""))
                        .environment(pathStore)
                        .onAppear {
                            pathStore.selectedTab = .tags
                        }
                case .tag_Edit(let tag):
                    TagEditor(tag: tag)
                        .environment(pathStore)
                        .onAppear {
                            pathStore.selectedTab = .tags
                        }
                case .tag_List:
                    TagsView()
                        .environment(pathStore)

                case .transaction_Create: Text("TBI")
                case .transaction_Detail(let transaction):
                    TransactionDetailsView(transaction: transaction)
                        .environment(pathStore)
                case .transaction_Edit: Text("TBI")
                case .transaction_List(let account):
                    AccountTransactionsView(account: account)
                        .environment(pathStore)
                }
            }
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
    ContentView()
        .modelContainer(Previewer().container)
#if os(macOS)
        .frame(width: 900, height: 500)
#endif
    // .modelContainer(for: Item.self, inMemory: true)
}
