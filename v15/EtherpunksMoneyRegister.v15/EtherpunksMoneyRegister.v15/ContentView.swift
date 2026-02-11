//
//  ContentView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftData
import SwiftUI

struct NavigationState {
    var primary: PathStore.Route? = .dashboard
    var secondary: PathStore.Route? = nil

    mutating func apply(_ route: PathStore.Route) {
        switch route {
        case .account_Create:
            self.primary = .account_Create
            self.secondary = nil

        case .account_Details(let account):
            self.primary = .transaction_List(account: account)
            self.secondary = .account_Details(account: account)

        case .account_Edit(let account):
            if self.primary == .transaction_List(account: account) {
                self.secondary = .account_Edit(account: account)
            } else {
                self.primary = .account_List
                self.secondary = .account_Edit(account: account)
            }

        case .account_List:
            // No-op for now (not implemented in original code)
            break

        case .dashboard:
            self.primary = .dashboard
            self.secondary = nil

        case .recurringGroup_Create:
            self.primary = .recurringGroup_List(recGroup: nil)
            self.secondary = .recurringGroup_Create

        case .recurringGroup_Details(let recGroup):
            self.primary = .recurringGroup_List(recGroup: recGroup)
            self.secondary = .recurringGroup_Details(recGroup: recGroup)

        case .recurringGroup_Edit(let recGroup):
            self.primary = .recurringGroup_List(recGroup: recGroup)
            self.secondary = .recurringGroup_Edit(recGroup: recGroup)

        case .recurringGroup_List:
            self.primary = .recurringGroup_List(recGroup: nil)
            self.secondary = nil

        case .recurringGroup_Reserve(let recGroup):
            self.primary = .recurringGroup_List(recGroup: recGroup)
            self.secondary = .recurringGroup_Reserve(recGroup: recGroup)

        case .recurringTransaction_Create:
            self.primary = .recurringTransaction_List(recTran: nil)
            self.secondary = .recurringTransaction_Create

        case .recurringTransaction_Create_FromTran(let tran):
            self.primary = .recurringTransaction_List(recTran: nil)
            self.secondary = .recurringTransaction_Create_FromTran(tran: tran)

        case .recurringTransaction_Details(let recTran):
            self.primary = .recurringTransaction_List(recTran: recTran)
            self.secondary = .recurringTransaction_Details(recTran: recTran)

        case .recurringTransaction_Edit(let recTran):
            self.primary = .recurringTransaction_List(recTran: recTran)
            self.secondary = .recurringTransaction_Edit(recTran: recTran)

        case .recurringTransaction_List:
            self.primary = .recurringTransaction_List(recTran: nil)
            self.secondary = nil

        case .recurringTransaction_Reserve(let recTran):
            self.primary = .recurringTransaction_List(recTran: recTran)
            self.secondary = .recurringTransaction_Reserve(recTran: recTran)

        case .report_Tax:
            self.primary = .report_Tax
            self.secondary = nil

        case .search:
            self.primary = .search
            self.secondary = nil

        case .settings:
            self.primary = .settings
            self.secondary = nil

        case .tag_Create:
            self.primary = .tag_List(tag: nil)
            self.secondary = .tag_Create

        case .tag_Details(let tag):
            if case .transaction_Detail(let transaction) = self.secondary {
                self.primary = .transaction_List(account: transaction.account)
                self.secondary = .tag_Details(tag: tag)
            } else {
                self.primary = .tag_List(tag: tag)
                self.secondary = .tag_Details(tag: tag)
            }

        case .tag_Edit(let tag):
            self.primary = .tag_List(tag: tag)
            self.secondary = .tag_Edit(tag: tag)

        case .tag_List:
            self.primary = .tag_List(tag: nil)
            self.secondary = nil

        case .transaction_Create:
            // Not yet implemented in original code; keep state unchanged
            break

        case .transaction_Edit(let tran):
            self.primary = .transaction_List(account: tran.account)
            self.secondary = .transaction_Edit(transaction: tran)

        case .transaction_Detail(let tran):
            self.primary = .transaction_List(account: tran.account)
            self.secondary = .transaction_Detail(transaction: tran)

        case .transaction_List(let account):
            self.primary = .transaction_List(account: account)
            self.secondary = nil
        }
    }
}

struct ContentView: View {
    @State var viewModel = ViewModel()
    @State private var nav = NavigationState()
    @State private var presentedRecurringTransaction: RecurringTransaction?

    @ViewBuilder
    private func contentView(for route: PathStore.Route) -> some View {
        switch route {
        case .account_Create: Text("TBI - Account Create")
        case .account_List: Text("Account List")
        case .account_Edit(let account):
            AccountEditView(account) { action in self.changeRoute(action) }
        case .account_Details(let account):
            AccountDetailView(account) { action in self.changeRoute(action) }
        case .dashboard:
            DashboardView { action in self.changeRoute(action) }
        case .recurringGroup_Create:
            Text("TBI - Recurring Group Create")
        case .recurringGroup_Details(let recGroup):
            Text("TBI - Recurring Group Details: \(recGroup.name)")
        case .recurringGroup_Edit(let recGroup):
            Text("TBI - Recurring Group Edit: \(recGroup.name)")
        case .recurringGroup_List(let recGroup):
            RecurringGroupListView(recGroup) { action in self.changeRoute(action) }
        case .recurringGroup_Reserve(let recGroup): Text("TBI - Recurring Group Reserve: \(recGroup.name)")
        case .recurringTransaction_Create:
            Text("TBI - Recurring Transaction Create")
        case .recurringTransaction_Create_FromTran(let tran):
            Text("TBI - Recurring Transaction Create From Transaction: \(tran.name)")
        case .recurringTransaction_Details(let recTran):
            // Detail is shown via popup; keep content column stable
            Text(recTran.name)
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
        case .transaction_Edit(let transaction): Text("Transaction Edit \(transaction.name)")
        case .transaction_List(let account):
            AccountTransactionListView(account) { action in self.changeRoute(action) }
        }
    }

    @ViewBuilder
    private func detailView(for route: PathStore.Route) -> some View {
        switch route {
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
            // Detail is shown via popup; keep detail column stable
            Text(recTran.name)
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
        case .transaction_Edit(let transaction): Text("Transaction Edit \(transaction.name)")
        case .transaction_List(let account):
            AccountTransactionListView(account) { action in self.changeRoute(action) }
        }
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(
                selection: Binding(
                    get: { self.nav.primary },
                    set: { self.nav.primary = $0 }
                ),
                accounts: self.viewModel.accounts,
                onAction: { action in self.changeRoute(action) }
            )
            .navigationSplitViewColumnWidth(200)
        } content: {
            if let route = nav.primary {
                contentView(for: route)
            }
        } detail: {
            if let route = nav.secondary {
                detailView(for: route)
            }
        }
        .onChange(of: nav.primary) { _, newValue in
            switch newValue {
            case .dashboard?, .recurringGroup_List?, .recurringTransaction_List?, .tag_List?, .search?, .settings?, .report_Tax?, nil:
                nav.secondary = nil
            default:
                break
            }
        }
        .sheet(item: $presentedRecurringTransaction) { recTran in
            RecurringTransactionDetailView(recTran) { action in
                // Allow actions inside the sheet to drive routing
                self.changeRoute(action)
            }
        }
        //.padding(20)
        .frame(
            minWidth: 1200, maxWidth: .infinity, minHeight: 750,
            maxHeight: .infinity)
    }

    func changeRoute(_ route: PathStore.Route) {
        if case .recurringTransaction_Details(let recTran) = route {
            self.presentedRecurringTransaction = recTran
            return
        }
        self.nav.apply(route)
    }
}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1200, minHeight: 750)
#endif
}

