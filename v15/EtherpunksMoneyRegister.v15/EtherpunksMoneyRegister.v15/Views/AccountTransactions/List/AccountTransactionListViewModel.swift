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

        var accountTransactions: [AccountTransaction] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account?) {
            self.dataSource = dataSource
            self.account = account

            self.accountList = self.dataSource.fetchAccounts()

            self.loadAccountTransactions()
        }

        func loadAccountTransactions() {
            if self.account != nil {
                self.accountTransactions = self.dataSource.fetchAccountTransactions(account: self.account!)
            } else {
                debugPrint("Account is null, cannot load transactions")
            }
        }
    }
}
