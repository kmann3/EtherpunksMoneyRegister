//
//  ContentView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel()
    @State private var selectedRoute: PathStore.Route? = .dashboard
    @State private var selectedSubRoute: PathStore.Route? = nil
    
    var body: some View {
        NavigationSplitView {
            List(selection: self.$selectedRoute) {
                NavigationLink(value: PathStore.Route.dashboard) {
                    Text("Dashboard")
                }

                NavigationLink(value: PathStore.Route.recurringGroup_List(recGroup: nil)) {
                    Text("Recurring Groups")
                }

                NavigationLink(value: PathStore.Route.recurringTransaction_List(recTran: nil)) {
                    Text("Recurring Transactions")
                }

                NavigationLink(value: PathStore.Route.tag_List(tag: nil)) {
                    Text("Tags")
                }

                NavigationLink(value: PathStore.Route.settings) {
                    Text("Settings")
                }

                NavigationLink(value: PathStore.Route.search) {
                    Text("Search")
                }

                Divider()

                Section(header: Text("Accounts")) {
                    Button("New Account"){
                        self.changeRoute(.account_Create)
                    }

                    ForEach(self.viewModel.accounts, id: \.id) { account in
                        HStack {
                            NavigationLink(value: PathStore.Route.transaction_List(account: account)) {
                                Text(account.name)
                            }
                            Spacer()
                            Button("Add Transaction", systemImage: "plus.circle"){
                                // Popup menu for adding credit/debit transaction
                            }

                            .labelStyle(.iconOnly)
                            .buttonStyle(.plain)
                        }
                    }
                }
                .headerProminence(.increased)
            }
            .navigationSplitViewColumnWidth(200)
        } content: {
            if let selectedRoute {
                switch selectedRoute {
                case .account_Create: Text("TBI - Account Create")
                case .account_List: Text("Account List")
                case .account_Edit(let account):
                    AccountEditView(account) { action in self.changeRoute(action) }
                case .account_Details(let account):
                    AccountDetailView(account) { action in self.changeRoute(action) }
                case .dashboard:
                    DashboardView { action in self.changeRoute(action) }
                        .onAppear {
                            self.selectedSubRoute = nil
                        }
                case .recurringGroup_Create:
                    Text("TBI - Recurring Group Create")
                case .recurringGroup_Details(let recGroup):
                    Text("TBI - Recurring Group Details: \(recGroup.name)")
                case .recurringGroup_Edit(let recGroup):
                    Text("TBI - Recurring Group Edit: \(recGroup.name)")
                case .recurringGroup_List(let recGroup):
                    RecurringGroupListView(recGroup) { action in self.changeRoute(action) }
                case .recurringGroup_Reserve(let recGroup): Text("TBI - Recurring Group Reserver: \(recGroup.name)")
                case .recurringTransaction_Create:
                    Text("TBI - Recurring Transaction Create")
                case .recurringTransaction_Create_FromTran(let tran):
                    Text("TBI - Recurring Transaction Create From Transaction: \(tran.name)")
                case .recurringTransaction_Details(let recTran):
                    RecurringTransactionDetailView(recTran) { action in self.changeRoute(action) }
                case .recurringTransaction_Edit(let recTran):
                    Text("TBI - Recurring Transaction Edit: \(recTran.name)")
                case .recurringTransaction_List(let recTran):
                    RecurringTransactionListView(recTran) { action in self.changeRoute(action) }
                case .recurringTransaction_Reserve(let recTran):
                    Text("TBI - Recurring Transaction Reserve: \(recTran.name)")
                case .report_Tax:
                    Text("TBI - Report Tax")
                case .search:
                    Text("TBI - Search")
                case .settings:
                    Text("TBI - Settings")
                case .tag_Create:
                    Text("TBI - Tag Create")
                case .tag_Details(let tag):
                    TagDetailView(tag: tag) { action in self.changeRoute(action) }
                case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag.name)")
                case .tag_List(let tag):
                    TagListView(tag) { action in self.changeRoute(action) }
                case .transaction_Create: Text("TBI - Transaction Create")
                case .transaction_Detail(let transaction):
                    AccountTransactionDetailsView(transaction) { action in self.changeRoute(action) }
                case .transaction_Edit(let transaction): Text("TBI - Transaction Edit \(transaction.name)")
                case .transaction_List(let account):
                    AccountTransactionListView(account) { action in self.changeRoute(action) }
                }
            }
        } detail: {
            if let selectedSubRoute {
                switch selectedSubRoute {
                case .account_Create:
                    Text("TBI - Account Create")
                case .account_List:
                    Text("Account List")
                case .account_Edit(let account):
                    AccountEditView(account) { action in self.changeRoute(action) }
                case .account_Details(let account):
                    AccountDetailView(account) { action in self.changeRoute(action) }
                case .dashboard: Text("TBI - Dashboard")
                case .recurringGroup_Create:
                    Text("TBI - Recurring Group Create")
                case .recurringGroup_Details(let recGroup):
                    ReserveGroupView(recGroup) { action in
                        self.changeRoute(action)
                    }
                case .recurringGroup_Edit(let recGroup):
                    Text("TBI - Recurring Group Edit: \(recGroup.name)")
                case .recurringGroup_List(let recGroup):
                    RecurringGroupListView(recGroup) { action in self.changeRoute(action) }
                case .recurringGroup_Reserve(let recGroup):
                    ReserveGroupView(recGroup) { action in self.changeRoute(action) }
                case .recurringTransaction_Create: Text("TBI - Recurring Transaction Create")
                case .recurringTransaction_Create_FromTran(let tranID): Text("TBI - Recurring Transaction Create From Transaction: \(tranID.name)")
                case .recurringTransaction_Details(let recTran):
                    RecurringTransactionDetailView(recTran) { action in
                        self.changeRoute(action)
                    }
                case .recurringTransaction_Edit(let recTran):
                    Text("TBI - Recurring Transaction Edit: \(recTran.name)")
                case .recurringTransaction_List(let recTran):
                    RecurringTransactionListView(recTran) { action in self.changeRoute(action) }
                case .recurringTransaction_Reserve(let recTran):
                    Text("TBI - Recurring Transaction Reserve: \(recTran.name)")
                case .report_Tax: Text("TBI - Report Tax")
                case .search: Text("TBI - Search")
                case .settings: Text("TBI - Settings")
                case .tag_Create: Text("TBI - Tag Create")
                case .tag_Details(let tag):
                    TagDetailView(tag: tag) { action in
                        self.changeRoute(action)
                    }
                case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag.name)")
                case .tag_List: Text("TBI - Tag List")
                case .transaction_Create: Text("TBI - Transaction Create")
                case .transaction_Detail(let transaction):
                    AccountTransactionDetailsView(transaction) { action in self.changeRoute(action) }
                case .transaction_Edit(let transaction): Text("TBI - Transaction Edit \(transaction.name)")
                case .transaction_List(let account):
                    AccountTransactionListView(account) { action in self.changeRoute(action) }
                }
            }
        }
        //.padding(20)
        .frame(
            minWidth: 950, maxWidth: .infinity, minHeight: 500,
            maxHeight: .infinity)
    }

    func changeRoute(_ route: PathStore.Route) {
        switch route {
        case .account_Create:
            self.selectedRoute = .account_Create
            self.selectedSubRoute = nil

        case .account_Details(let account):
            self.selectedRoute = .transaction_List(account: account)
            self.selectedSubRoute = .account_Details(account: account)

        case .account_Edit(let account):
            // If we're editing from the transaction list then replace a transaction detail with the edit screen
            if self.selectedRoute == .transaction_List(account: account) {
                self.selectedSubRoute = .account_Edit(account: account)
            } else {
                self.selectedRoute = .account_List
                self.selectedSubRoute = .account_Edit(account: account)
            }

        case .account_List: // Is this even used anymore now?
            debugPrint(".Account_List not yet implemented")

        case .dashboard:
            self.selectedRoute = .dashboard
            self.selectedSubRoute = nil

        case .recurringGroup_Create:
            self.selectedRoute = .recurringGroup_List(recGroup: nil)
            self.selectedSubRoute = .recurringGroup_Create

        case .recurringGroup_Details(let recGroup):
            self.selectedRoute = .recurringGroup_List(recGroup: recGroup)
            self.selectedSubRoute = .recurringGroup_Details(recGroup: recGroup)

        case .recurringGroup_Edit(let recGroup):
            self.selectedRoute = .recurringGroup_List(recGroup: recGroup)
            self.selectedSubRoute = .recurringGroup_Edit(recGroup: recGroup)

        case .recurringGroup_List:
            self.selectedRoute = .recurringGroup_List(recGroup: nil)
            self.selectedSubRoute = nil

        case .recurringGroup_Reserve(let recGroup):
            self.selectedRoute = .recurringGroup_List(recGroup: recGroup)
            self.selectedSubRoute = .recurringGroup_Reserve(recGroup: recGroup)

        case .recurringTransaction_Create:
            self.selectedRoute = .recurringTransaction_List(recTran: nil)
            self.selectedSubRoute = .recurringTransaction_Create

        case .recurringTransaction_Create_FromTran(let tran):
            self.selectedRoute = .recurringTransaction_List(recTran: nil)
            self.selectedSubRoute = .recurringTransaction_Create_FromTran(tran: tran)

        case .recurringTransaction_Details(let recTran):
            self.selectedRoute = .recurringTransaction_List(recTran: recTran)
            self.selectedSubRoute = .recurringTransaction_Details(recTran: recTran)

        case .recurringTransaction_Edit(let recTran):
            self.selectedRoute = .recurringTransaction_List(recTran: recTran)
            self.selectedSubRoute = .recurringTransaction_Edit(recTran: recTran)

        case .recurringTransaction_List:
            self.selectedRoute = .recurringTransaction_List(recTran: nil)
            self.selectedSubRoute = nil

        case .recurringTransaction_Reserve(let recTran):
            self.selectedRoute = .recurringTransaction_List(recTran: recTran)
            self.selectedSubRoute = .recurringTransaction_Reserve(recTran: recTran)

        case .report_Tax:
            self.selectedRoute = .report_Tax
            self.selectedSubRoute = nil

        case .search:
            self.selectedRoute = .search
            self.selectedSubRoute = nil

        case .settings:
            self.selectedRoute = .settings
            self.selectedSubRoute = nil

        case .tag_Create:
            self.selectedRoute = .tag_List(tag: nil)
            self.selectedSubRoute = .tag_Create

        case .tag_Details(let tag):
            if case .transaction_Detail(let transaction) = self.selectedSubRoute {
                self.selectedRoute = .transaction_List(account: transaction.account)
                self.selectedSubRoute = .tag_Details(tag: tag)
            } else {
                self.selectedRoute = .tag_List(tag: tag)
                self.selectedSubRoute = .tag_Details(tag: tag)
            }

        case .tag_Edit(let tag):
            self.selectedRoute = .tag_List(tag: tag)
            self.selectedSubRoute = .tag_Edit(tag: tag)

        case .tag_List:
            self.selectedRoute = .tag_List(tag: nil)
            self.selectedSubRoute = nil

        case .transaction_Create:
            debugPrint(".transaction_Create is not yet implemented")

        case .transaction_Edit(let tran):
            self.selectedRoute = .transaction_List(account: tran.account)
            self.selectedSubRoute = .transaction_Edit(transaction: tran)

        case .transaction_Detail(let tran):
            self.selectedRoute = .transaction_List(account: tran.account)
            self.selectedSubRoute = .transaction_Detail(transaction: tran)

        case .transaction_List(let account):
            self.selectedRoute = .transaction_List(account: account)
            self.selectedSubRoute = nil
        }
    }
}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1200, minHeight: 750)
#endif
}
