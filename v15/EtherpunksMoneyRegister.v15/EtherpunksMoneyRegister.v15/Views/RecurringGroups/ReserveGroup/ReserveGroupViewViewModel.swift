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
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveGroup: RecurringGroup
        var transactionQueue: [AccountTransactionQueueItem] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, reserveGroup: RecurringGroup) {
            self.dataSource = dataSource
            self.accounts = dataSource.fetchAccounts()
            self.reserveGroup = reserveGroup

            self.reserveGroup.recurringTransactions!.sorted(by: ({$0.name < $1.name})).forEach {
                transactionQueue.append(AccountTransactionQueueItem(recurringTransaction: $0))
            }
        }
    }

    public class AccountTransactionQueueItem: Identifiable, ObservableObject {
        var id: UUID = UUID()
        var accountTransaction: AccountTransaction
        var action: Action = .enable

        init(recurringTransaction: RecurringTransaction) {
            self.accountTransaction = AccountTransaction(recurringTransaction: recurringTransaction)
            self.accountTransaction.amount = abs(recurringTransaction.amount)
        }
    }

    enum Action {
        case enable
        case skip
        case ignore
    }
}
