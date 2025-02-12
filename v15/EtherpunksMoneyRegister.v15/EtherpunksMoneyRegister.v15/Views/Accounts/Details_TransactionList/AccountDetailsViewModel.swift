//
//  AccountDetailsViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountDetailsView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var pathStore: PathStore

        var account: Account

        var accountTransactions: [AccountTransaction] = []
//        private var isLoading = false
//        private var hasMoreTransactions = true
//        private var currentAccountTransactionPage = 0
//        private var currentSearchPage = 0
//        private var transactionsPerPage = 10

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            self.account = account

            self.accountTransactions = self.dataSource.fetchAccountTransactions(account: self.account)
        }
    }
}
