//
//  ReserveGroupViewViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/25/25.
//

import Foundation
import SwiftData
import SwiftUI

extension ReserveGroupViewView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveGroup: RecurringGroup
        var transactionQueue: [AccountTransactionQueueItem] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, reserveGroup: RecurringGroup) {
            self.dataSource = dataSource
            self.accounts = dataSource.fetchAccounts()
            self.reserveGroup = reserveGroup

            self.reserveGroup.recurringTransactions!.forEach {
                transactionQueue.append(AccountTransactionQueueItem(account: $0.defaultAccount, recurringTransaction: $0))
            }
        }
    }

    public class AccountTransactionQueueItem {
        var account: Account
        var accountTransaction: AccountTransaction
        var amount: Decimal = 0
        var isEnabled: Bool = true
        var isSkipped: Bool = false

        init(account: Account, recurringTransaction: RecurringTransaction, amount: Decimal = 0, isEnabled: Bool = true, isSkipped: Bool = false) {
            self.account = account
            self.accountTransaction = AccountTransaction(recurringTransaction: recurringTransaction)
            self.amount = amount
            self.isEnabled = isEnabled
            self.isSkipped = isSkipped
        }
    }
}
