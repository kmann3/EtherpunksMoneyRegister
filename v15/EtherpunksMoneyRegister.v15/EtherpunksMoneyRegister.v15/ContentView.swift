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
    @State private var selectedRoute: PathStore.Route? = .dashboard
    @State private var selectedSubRoute: PathStore.Route? = nil

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedRoute) {
                NavigationLink(value:  PathStore.Route.dashboard) {
                    Text("Dashboard")
                }

                NavigationLink(value:  PathStore.Route.recurringGroup_List) {
                    Text("Recurring Groups")
                }

                NavigationLink(value:  PathStore.Route.recurringTransaction_List) {
                    Text("Recurring Transactions")
                }

                NavigationLink(value:  PathStore.Route.tag_List(tag: nil)) {
                    Text("Tags")
                }

                NavigationLink(value:  PathStore.Route.settings) {
                    Text("Settings")
                }

                NavigationLink(value:  PathStore.Route.search) {
                    Text("Search")
                }

                Text("")

                HStack {
                    Text("Accounts")
                    Spacer()
                    Button {
                        changeRoute(.account_Create)
                    } label: {
                        Text("+")
                    }
                }


                Divider()

                ForEach(viewModel.accounts, id: \.id) { account in
                    NavigationLink(value: PathStore.Route.transaction_List(account: account)) {
                        Text(account.name)
                    }
                }
            }
            .navigationSplitViewColumnWidth(200)
        } content: {
            if let selectedRoute {
                switch selectedRoute {
                case .account_Create: Text("TBI - Account Create")
                case .account_List: Text("Account List")
                case .account_Edit(let account): Text("TBI - Account Edit \(account)")
                case .account_Details(let account): Text("TBI - Account Details \(account)")

                case .dashboard:
                    DashboardView() { action in
                        changeRoute(action)
                    }
                    .onAppear {
                        self.selectedSubRoute = nil
                    }

                case .recurringGroup_Create: Text("TBI - Recurring Group Create")
                case .recurringGroup_Details(let recGroup): Text("TBI - Recurring Group Details: \(recGroup)")
                case .recurringGroup_Edit(let recGroup): Text("TBI - Recurring Group Edit: \(recGroup)")
                case .recurringGroup_List: Text("TBI - Recurring Group List")
                case .recurringGroup_Reserve(let recGroup): Text("TBI - Recurring Group Reserver: \(recGroup)")

                case .recurringTransaction_Create: Text("TBI - Recurring Transaction Create")
                case .recurringTransaction_Create_FromTrans(let transID): Text("TBI - Recurring Transaction Create From Transaction: \(transID)")
                case .recurringTransaction_Details(let recTran): Text("TBI - Recurring Transaction Details: \(recTran)")
                case .recurringTransaction_Edit(let recTran): Text("TBI - Recurring Transaction Edit: \(recTran)")
                case .recurringTransaction_List: Text("TBI - Recurring Transaction List")
                case .recurringTransaction_Reserve(let recTran): Text("TBI - Recurring Transaction Reserve: \(recTran)")

                case .report_Tax: Text("TBI - Report Tax")
                case .search: Text("TBI - Search")
                case .settings: Text("TBI - Settings")

                case .tag_Create: Text("TBI - Tag Create")
                case .tag_Details(let tag):
                    TagDetailView(tag: tag) { action in
                        changeRoute(action)
                    }
                case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag)")
                case .tag_List(let tag):
                    TagListView(selectedTag: tag) { action in
                        changeRoute(action)
                    }

                case .transaction_Create: Text("TBI - Transaction Create")
                case .transaction_Detail(let transaction):
                    AccountTransactionDetailsView(tran: transaction) { action in
                        changeRoute(action)
                    }
                case .transaction_Edit(let transaction): Text("TBI - Transaction Edit \(transaction)")
                case .transaction_List(let account):
                    AccountTransactionListView(account: account) { action in
                        changeRoute(action)
                    }
                }
            }
        } detail: {
            if let selectedSubRoute {
                switch selectedSubRoute {
                case .account_Create: Text("TBI - Account Create")
                case .account_List: Text("Account List")
                case .account_Edit(let account): Text("TBI - Account Edit \(account)")
                case .account_Details(let account): Text("TBI - Account Details \(account)")

                case .dashboard: Text("TBI - Dashboard")

                case .recurringGroup_Create: Text("TBI - Recurring Group Create")
                case .recurringGroup_Details(let recGroup): Text("TBI - Recurring Group Details: \(recGroup)")
                case .recurringGroup_Edit(let recGroup): Text("TBI - Recurring Group Edit: \(recGroup)")
                case .recurringGroup_List: Text("TBI - Recurring Group List")
                case .recurringGroup_Reserve(let recGroup):
                    ReserveGroupView(group: recGroup) { action in changeRoute(action) }

                case .recurringTransaction_Create: Text("TBI - Recurring Transaction Create")
                case .recurringTransaction_Create_FromTrans(let transID): Text("TBI - Recurring Transaction Create From Transaction: \(transID)")
                case .recurringTransaction_Details(let recTran): Text("TBI - Recurring Transaction Details: \(recTran)")
                case .recurringTransaction_Edit(let recTran): Text("TBI - Recurring Transaction Edit: \(recTran)")
                case .recurringTransaction_List: Text("TBI - Recurring Transaction List")
                case .recurringTransaction_Reserve(let recTran): Text("TBI - Recurring Transaction Reserve: \(recTran)")

                case .report_Tax: Text("TBI - Report Tax")
                case .search: Text("TBI - Search")
                case .settings: Text("TBI - Settings")

                case .tag_Create: Text("TBI - Tag Create")
                case .tag_Details(let tag):
                    TagDetailView(tag: tag) { action in
                        changeRoute(action)
                    }
                case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag)")
                case .tag_List: Text("TBI - Tag List")

                case .transaction_Create: Text("TBI - Transaction Create")
                case .transaction_Detail(let transaction):
                    AccountTransactionDetailsView(tran: transaction) { action in
                        changeRoute(action)
                    }

                case .transaction_Edit(let transaction): Text("TBI - Transaction Edit \(transaction)")
                case .transaction_List(let account):
                    AccountTransactionListView(account: account) { action in
                        changeRoute(action)
                    }
                }
            }
        }
        .padding(20)
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
            if (self.selectedRoute == .transaction_List(account: account)) {
                self.selectedSubRoute = .account_Edit(account: account)
            } else {
                self.selectedRoute = .account_List
                self.selectedSubRoute = .account_Edit(account: account)
            }
            break

        case .account_List: // Is this even used anymore now?
            debugPrint(".Account_List not yet implemented")
            break

        case .dashboard:
            self.selectedRoute = .dashboard
            self.selectedSubRoute = nil
            break

        case .recurringGroup_Create:
            self.selectedRoute = .recurringGroup_List
            self.selectedSubRoute = .recurringGroup_Create
            break

        case .recurringGroup_Details(let recGroup):
            self.selectedRoute = .recurringGroup_List
            self.selectedSubRoute = .recurringGroup_Details(recGroup: recGroup)
            break

        case .recurringGroup_Edit(let recGroup):
            self.selectedRoute = .recurringGroup_List
            self.selectedSubRoute = .recurringGroup_Edit(recGroup: recGroup)
            break

        case .recurringGroup_List:
            self.selectedRoute = .recurringGroup_List
            self.selectedSubRoute = nil
            break

        case .recurringGroup_Reserve(let recGroup):
            self.selectedRoute = .recurringGroup_List
            self.selectedSubRoute = .recurringGroup_Reserve(recGroup: recGroup)

        case .recurringTransaction_Create:
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Create
            break

        case .recurringTransaction_Create_FromTrans(let tran):
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Create_FromTrans(tran: tran)
            break

        case .recurringTransaction_Details(let recTrans):
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Details(recTrans: recTrans)
            break

        case .recurringTransaction_Edit(let recTrans):
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Edit(recTrans: recTrans)
            break

        case .recurringTransaction_List:
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = nil
            break

        case .recurringTransaction_Reserve(let recTrans):
            self.selectedRoute = .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Reserve(recTrans: recTrans)

        case .report_Tax:
            self.selectedRoute = .report_Tax
            self.selectedSubRoute = nil
            break

        case .search:
            self.selectedRoute = .search
            self.selectedSubRoute = nil
            break

        case .settings:
            self.selectedRoute = .settings
            self.selectedSubRoute = nil
            break

        case .tag_Create:
            self.selectedRoute = .tag_List(tag: nil)
            self.selectedSubRoute = .tag_Create
            break

        case .tag_Details(let tag):
            if case .transaction_Detail(let transaction) = self.selectedSubRoute {
                self.selectedRoute = .transaction_List(account: transaction.account)
                self.selectedSubRoute = .tag_Details(tag: tag)
            } else {
                self.selectedRoute = .tag_List(tag: tag)
                self.selectedSubRoute = .tag_Details(tag: tag)
            }
            break

        case .tag_Edit(let tag):
            self.selectedRoute = .tag_List(tag: tag)
            self.selectedSubRoute = .tag_Edit(tag: tag)
            break

        case .tag_List:
            self.selectedRoute = .tag_List(tag: nil)
            self.selectedSubRoute = nil
            break

        case .transaction_Create:
            debugPrint(".transaction_Create is not yet implemented")
            break

        case .transaction_Edit(let tran):
            self.selectedRoute = .transaction_List(account: tran.account)
            self.selectedSubRoute = .transaction_Edit(transaction: tran)
            break

        case .transaction_Detail(let tran):
            self.selectedRoute = .transaction_List(account: tran.account)
            self.selectedSubRoute = .transaction_Detail(transaction: tran)
            break

        case .transaction_List(let account):
            self.selectedRoute = .transaction_List(account: account)
            self.selectedSubRoute = nil
            break
        }
    }

}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1200, minHeight: 750)
#endif
}
