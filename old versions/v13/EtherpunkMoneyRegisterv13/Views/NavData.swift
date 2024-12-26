//
//  NavData.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/23/24.
//

import Foundation
class NavData: Hashable {
    var navView: NavView
    var account: Account? = nil
    var transaction: AccountTransaction? = nil
    var transactionTag: TransactionTag? = nil
    var recurringTransaction: RecurringTransaction? = nil
    var recurringTransactionGroup: RecurringTransactionGroup? = nil

    init(navView: NavView, account: Account? = nil, transaction: AccountTransaction? = nil, transactionTag: TransactionTag? = nil, recurringTransaction: RecurringTransaction? = nil, recurringTransactionGroup: RecurringTransactionGroup? = nil) {
        self.navView = navView
        self.account = account
        self.transaction = transaction
        self.transactionTag = transactionTag
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
