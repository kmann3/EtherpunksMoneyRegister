//
//  AccountDetailsViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionListView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var account: Account?
        var accountList: [Account] = []
        var endOfListText: String = "End of list"

        var accountTransactions: [AccountTransaction] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account?) {
            self.dataSource = dataSource
            self.account = account

            self.accountList = self.dataSource.fetchAccounts()

            self.loadAccountTransactions()
        }

        func loadAccountTransactions() {
            if self.account != nil {
                let transactionData = self.dataSource.fetchAccountTransactions(account: self.account!)
                self.accountTransactions = transactionData.transactions
                if transactionData.remainingTransactionsCount != 0 {
                    self.endOfListText = "\(transactionData.remainingTransactionsCount) more..."
                }
            } else {
                debugPrint("Account is null, cannot load transactions")
            }
        }
    }
}
