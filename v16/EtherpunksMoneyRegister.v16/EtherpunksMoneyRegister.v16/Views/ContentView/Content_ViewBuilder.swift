//
//  ContentViewBuilder.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI

extension ContentView {
    @ViewBuilder
    internal func contentViewBuilder(for route: PathStore.Route) -> some View {
        switch route {
        case .account_Create: Text(verbatim: "TBI - Account Create")
        case .account_List: Text(verbatim: "Account List")
        case .account_Edit(let account): Text(verbatim: "TBI: Account Edit \(account)")
            //AccountEditView(account) { action in self.changeRoute(action) }
        case .account_Details(let account): Text(verbatim: "Account Details \(account)")
            //AccountDetailView(account) { action in self.changeRoute(action) }
        case .dashboard: Text(verbatim: "Dashboard")
            //DashboardView { action in self.changeRoute(action) }
        case .recurringGroup_Create:
            Text(verbatim: "TBI - Recurring Group Create")
        case .recurringGroup_Details(let recGroup):
            Text(verbatim: "TBI - Recurring Group Details: \(recGroup.name)")
        case .recurringGroup_Edit(let recGroup):
            Text(verbatim: "TBI - Recurring Group Edit: \(recGroup.name)")
        case .recurringGroup_List(let recGroup): Text(verbatim: "recurringGroup_List \(String(describing: recGroup))")
            //RecurringGroupListView(recGroup) { action in self.changeRoute(action) }
        case .recurringGroup_Reserve(let recGroup): Text(verbatim: "TBI - Recurring Group Reserve: \(recGroup.name)")
        case .recurringTransaction_Create:
            Text(verbatim: "TBI - Recurring Transaction Create")
        case .recurringTransaction_Create_FromTran(let tran):
            Text(verbatim: "TBI - Recurring Transaction Create From Transaction: \(tran.name)")
        case .recurringTransaction_Details(let recTran):
            // Detail is shown via popup; keep content column stable
            Text(recTran.name)
        case .recurringTransaction_Edit(let recTran):
            Text(verbatim: "TBI - Recurring Transaction Edit: \(recTran.name)")
        case .recurringTransaction_List(let recTran): Text(verbatim: "RecurringTransactionListView \(String(describing: recTran))")
            //RecurringTransactionListView(recTran) { action in self.changeRoute(action) }
        case .recurringTransaction_Reserve(let recTran):
            Text(verbatim: "TBI - Recurring Transaction Reserve: \(recTran.name)")
        case .report_Tax:
            Text(verbatim: "TBI - Report Tax")
        case .search:
            Text(verbatim: "TBI - Search")
        case .settings:
            Text(verbatim: "TBI - Settings")
        case .tag_Create:
            Text(verbatim: "TBI - Tag Create")
        case .tag_Details(let tag): Text(verbatim: "TagDetailView \(tag)")
            //TagDetailView(tag: tag) { action in self.changeRoute(action) }
        case .tag_Edit(let tag): Text(verbatim: "TBI - Tag Edit: \(tag)")
        case .tag_List(let tag): Text(verbatim: "TagListView \(String(describing: tag))")
            //TagListView(tag) { action in self.changeRoute(action) }
        case .transaction_Create: Text(verbatim: "TBI - Transaction Create")
        case .transaction_Detail(let transaction): Text(verbatim: "Account Transaction Details View \(transaction)")
            //AccountTransactionDetailsView(transaction) { action in self.changeRoute(action) }
        case .transaction_Edit(let transaction): Text(verbatim: "Transaction Edit \(transaction)")
        case .transaction_List(let account): Text(verbatim: "Account Transaction List \(account)")
            //AccountTransactionListView(account) { action in self.changeRoute(action) }
        }
    }
}
