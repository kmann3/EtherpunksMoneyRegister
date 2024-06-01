//
//  NavData.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import Foundation


class NavData: Hashable {
    var navView: NavView
    var account: Account? = nil
    var transaction: AccountTransaction? = nil
    var tag: Tag? = nil
    var recurringTransaction: RecurringTransaction? = nil
    var recurringTransactionGroup: RecurringTransactionGroup? = nil
    
    init(navView: NavView, account: Account? = nil, transaction: AccountTransaction? = nil, tag: Tag? = nil, recurringTransaction: RecurringTransaction? = nil, recurringTransactionGroup: RecurringTransactionGroup? = nil) {
        self.navView = navView
        self.account = account
        self.transaction = transaction
        self.tag = tag
        self.recurringTransaction = recurringTransaction
        self.recurringTransactionGroup = recurringTransactionGroup
    }
    
    static func == (lhs: NavData, rhs: NavData) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
