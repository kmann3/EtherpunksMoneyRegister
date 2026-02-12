//
//  NavigationState.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

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
            // TODO: Implement
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
            // TODO: Implement
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
