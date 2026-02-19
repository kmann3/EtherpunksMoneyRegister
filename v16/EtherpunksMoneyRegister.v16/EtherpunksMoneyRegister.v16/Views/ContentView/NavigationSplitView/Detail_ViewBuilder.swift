//
//  Detail_ViewBuilder.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI

extension ContentView {
    @ViewBuilder
    internal func detailViewBuilder(for route: PathStore.Route) -> some View {
#if DEBUG
        let _ = { print("DetailViewBuilder: \(route)") }()
#endif
        switch route {
        case .account_Create:
            Text("TBI - Account Create")
        case .account_List:
            Text("Account List")
        case .account_Edit(let account): Text("Account Edit \(account.name)")
            //AccountEditView(account) { action in self.changeRoute(action) }
        case .account_Details(let account):
            AccountDetailView(account) { action in self.changeRoute(action) }
        case .dashboard: Text("TBI - Dashboard")
        case .recurringGroup_Create:
            Text("TBI - Recurring Group Create")
        case .recurringGroup_Details(let recGroup): Text("TBI - Recurring Group Details: \(recGroup.name)")
            //ReserveGroupView(recGroup) { action in self.changeRoute(action) }
        case .recurringGroup_Edit(let recGroup):
            Text("TBI - Recurring Group Edit: \(recGroup.name)")
        case .recurringGroup_List(let recGroup): Text("TBI - Recurring Group List \(String(describing: recGroup))")
            //RecurringGroupListView(recGroup) { action in self.changeRoute(action) }
        case .recurringGroup_Reserve(let recGroup): Text("TBI - Recurring Group Reserve: \(recGroup.name)")
            //ReserveGroupView(recGroup) { action in self.changeRoute(action) }
        case .recurringTransaction_Create: Text("TBI - Recurring Transaction Create")
        case .recurringTransaction_Create_FromTran(let tranID): Text("TBI - Recurring Transaction Create From Transaction: \(tranID.name)")
        case .recurringTransaction_Details(let recTran): Text("Recurring Transaction Details \(recTran.name)")
        case .recurringTransaction_Edit(let recTran):
            Text("TBI - Recurring Transaction Edit: \(recTran.name)")
        case .recurringTransaction_List(let recTran): Text("TBI - Recurring Transaction List \(String(describing: recTran))")
            //RecurringTransactionListView(recTran) { action in self.changeRoute(action) }
        case .recurringTransaction_Reserve(let recTran): Text("TBI - Recurring Transaction Reserve: \(recTran.name)")
        case .report_Tax: Text("TBI - Report Tax")
        case .search: Text("TBI - Search")
        case .settings: Text("TBI - Settings")
        case .tag_Create: Text("TBI - Tag Create")
        case .tag_Details(let tag): Text("TBI - Tag Details: \(tag.name)")
            //TagDetailView(tag: tag) { action in self.changeRoute(action) }
        case .tag_Edit(let tag): Text("TBI - Tag Edit: \(tag.name)")
        case .tag_List: Text("TBI - Tag List")
        case .transaction_Create: Text("TBI - Transaction Create")
        case .transaction_Detail(let transaction): Text("Transaction Detail \(transaction.name)")
            //AccountTransactionDetailsView(transaction) { action in self.changeRoute(action) }
        case .transaction_Edit(let transaction):
            AccountTransactionEditView(transaction) { action in self.changeRoute(action) }
        case .transaction_List(let account):
            AccountTransactionListView(account) { action in self.changeRoute(action) }
        }
    }
}
