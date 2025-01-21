//
//  ContentView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel = ViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.pathStore.path) {
            TabView(selection: $viewModel.pathStore.selectedTab) {
                Tab(
                    MenuOptionsEnum.dashboard.title,
                    systemImage: MenuOptionsEnum.dashboard.iconName,
                    value: MenuOptionsEnum.dashboard
                ) {
                    DashboardView()
                }
                .customizationID(MenuOptionsEnum.dashboard.tabId)

                Tab(
                    MenuOptionsEnum.accounts.title,
                    systemImage: MenuOptionsEnum.accounts.iconName,
                    value: MenuOptionsEnum.accounts
                ) {
                    Text("Accounts")
                    //AccountsView()
                }
                .customizationID(MenuOptionsEnum.accounts.tabId)

                Tab(
                    MenuOptionsEnum.recurringTransactions.title,
                    systemImage: MenuOptionsEnum.recurringTransactions.iconName,
                    value: MenuOptionsEnum.recurringTransactions
                ) {
                    Text("Recurring Transactions")
                    //RecurringTransactionsView()
                }
                .customizationID(MenuOptionsEnum.recurringTransactions.tabId)

                Tab(
                    MenuOptionsEnum.tags.title,
                    systemImage: MenuOptionsEnum.tags.iconName,
                    value: MenuOptionsEnum.tags
                ) {
                    Text("Tags")
                    //TagView()
                }
                .customizationID(MenuOptionsEnum.tags.tabId)

                Tab(
                    MenuOptionsEnum.reports.title,
                    systemImage: MenuOptionsEnum.reports.iconName,
                    value: MenuOptionsEnum.reports
                ) {
                    Text("Reports")
                    //ReportsView()
                }
                .customizationID(MenuOptionsEnum.reports.tabId)

                Tab(
                    MenuOptionsEnum.search.title,
                    systemImage: MenuOptionsEnum.search.iconName,
                    value: MenuOptionsEnum
                        .search
                ) {
                    Text("Search")
                    //SearchView()
                }
                .customizationID(MenuOptionsEnum.search.tabId)

                Tab(
                    MenuOptionsEnum.settings.title,
                    systemImage: MenuOptionsEnum.settings.iconName,
                    value: MenuOptionsEnum.settings
                ) {
                    //SettingsView()
                }
                .customizationID(MenuOptionsEnum.settings.tabId)
#if os(iOS)
                Tab(value: .search, role: .search) {
                    // TODO: Mobile search
                    //SearchView()
                }
#endif
            }
#if os(macOS)
            .tabViewStyle(.grouped)
#else
            .tabViewStyle(.automatic)
#endif
            .navigationDestination(for: PathStore.Route.self) { route in
                switch route {
                case .account_Create: Text("TBI")
                case .account_Details(let account):
                    Text("TBI: \(account.name)")
                case .account_Edit: Text("TBI")
                case .account_List:
                    //AccountsView()
                    Text("TBI")


                case .dashboard:
                    Text("TBI")
//                    DashboardView()
//                        .onAppear {
//                            viewModel.pathStore.selectedTab = .dashboard
//                        }

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
                    Text("TBI")
//                    TagEditorView(tag: TransactionTag(name: ""))
//                        .onAppear {
//                            viewModel.pathStore.selectedTab = .tags
//                        }
                case .tag_Edit(let tag):
                    Text("Tag: \(tag.name)")
//                    TagEditorView(tag: tag)
//                        .onAppear {
//                            viewModel.pathStore.selectedTab = .tags
//                        }
                case .tag_List:
                    Text("TBI")
//                    TagView()
//                        .modelContext(MoneyDataSource.shared.modelContext)

                case .transaction_Create: Text("TBI")
                case .transaction_Detail(let transaction): Text("TBI: \(transaction.name)")
                case .transaction_Edit: Text("TBI")
                case .transaction_List(let account): Text("TBI: \(account.name)")
                }
            }
        }
        .frame(
            minWidth: 850, maxWidth: .infinity, minHeight: 500,
            maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1000, minHeight: 750)
#endif
}
