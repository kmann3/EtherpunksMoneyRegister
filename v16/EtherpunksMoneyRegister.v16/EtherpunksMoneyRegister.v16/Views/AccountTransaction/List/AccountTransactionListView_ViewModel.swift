//
//  AccountTransactionListView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionListView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource

        var account: Account?
        var accountList: [Account] = []
        var endOfListText: String = "End of list"

        var accountTransactions: [AccountTransaction] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account?) {
            self.dataSource = dataSource
            self.account = account

            self.accountList = self.dataSource.fetchAccounts()

            if self.account != nil {
                self.loadAccountTransactions()
            }
        }

        func loadAccountTransactions() {
            let transactionData = self.dataSource.fetchAccountTransactions(account: self.account!)
            self.accountTransactions = transactionData.transactions
            if transactionData.hasMoreTransactions == true {
                self.endOfListText = "more transactions available and not loaded"
            }
        }
    }
}
