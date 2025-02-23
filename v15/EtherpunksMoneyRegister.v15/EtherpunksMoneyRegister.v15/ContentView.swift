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
    @State private var route: PathStore.Route? = .dashboard
    @State private var selectedRoute: PathStore.Route? = nil
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

                NavigationLink(value:  PathStore.Route.tag_List) {
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
                        changeRoute(.account_Create, value: nil)
                    } label: {
                        Text("+")
                    }
                }

                Divider()

                ForEach(viewModel.accounts, id: \.id) { account in
                    Button {
                        changeRoute(.transaction_List(account: account), value: account)
                    } label: {
                        Text(account.name)
                    }
                }
            }
        } content: {
            if let selectedRoute {
                switch selectedRoute {
                case .dashboard:
                    DashboardView() { r in
                        switch r {
                        case .recurringGroup_Edit(let group):
                            changeRoute(r, value: group)

                        case .recurringTransaction_Edit(let rec):
                            changeRoute(r, value: rec)

                        case .transaction_Detail(let transaction):
                            changeRoute(r, value: transaction)

                        case .transaction_List(let account):
                            changeRoute(r, value: account)
                        default: break
                        }
                    }
                case .recurringGroup_List: Text("TBI - Recurring Group List")
                case .recurringTransaction_List: Text("TBI - Recurring Transaction List")
                case .tag_List: Text("TBI - Tag List")
                case .transaction_List(let account):
                    AccountTransactionsView(account: account) { r in
                        switch r {
                        case .transaction_Detail(let transaction):

                            changeRoute(r, value: transaction)
                        default:
                            debugPrint(r)
                            break
                        }
                    }
                    .frame(width: 300)

                case .settings: Text("TBI - Settings")
                default: Text("TBI - \(selectedRoute)")
                }
            }

        } detail: {

            if let selectedSubRoute {
                switch selectedSubRoute {
                case .account_Details(let account):
                    AccountTransactionsView(account: account) { t in
                        changeRoute(t, value: nil)
                    }

                case .recurringGroup_Details(let recGroup): Text("TBI - Recurring Group Details: \(recGroup)")
                case .recurringGroup_Edit(let recGroup): Text("TBI - Recurring Group Edit: \(recGroup)")
                case .recurringTransaction_Details(let recTrans): Text("TBI - Recurring Transaction Details: \(recTrans)")
                case .recurringTransaction_Edit(let recTrans): Text("TBI - Recurring Transaction Edit: \(recTrans)")
                case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag)")
                case .transaction_Detail(let transaction):
                    Text("TBI - Transaction Detail: \(transaction)")

                case .transaction_List(let account):
                    AccountTransactionsView(account: account) { r in
                        switch r {
                        case .transaction_Detail(let transaction):

                            changeRoute(r, value: transaction)
                        default:
                            debugPrint(r)
                            break
                        }
                    }
                    .frame(width: 600)
                default:
                    Text("Empty")
                }
            }

        }
        .padding(20)
        .frame(
            minWidth: 950, maxWidth: .infinity, minHeight: 500,
            maxHeight: .infinity)
    }

    func changeRoute(_ route: PathStore.Route, value: Any?) {
        switch route {
        case .account_Create:
            self.selectedRoute = .account_Create
            self.selectedSubRoute = nil
            
        case .recurringGroup_Edit:
            self.selectedRoute =
                .recurringGroup_List
            self.selectedSubRoute = .recurringGroup_Edit(recGroup: value as! RecurringGroup)

        case .recurringTransaction_Edit(let rec): self.selectedRoute =
                .recurringTransaction_List
            self.selectedSubRoute = .recurringTransaction_Edit(recTrans: rec)

        case .transaction_Detail:
            let transaction = value as! AccountTransaction
            self.selectedRoute = .transaction_List(account: transaction.account!)
            self.selectedSubRoute = .transaction_Detail(transaction: transaction)

        case .transaction_List:
            self.selectedRoute = .transaction_List(account: value as! Account)
            self.selectedSubRoute = nil
        default: break
        }
    }
}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1000, minHeight: 750)
#endif
}
