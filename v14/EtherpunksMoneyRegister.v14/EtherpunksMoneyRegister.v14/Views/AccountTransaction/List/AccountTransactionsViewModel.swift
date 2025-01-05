//
//  AccountTransactionsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/3/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionsView {
    @Observable
    class ViewModel {
        var isLoading = false
        var isDeleteWarningPresented: Bool = false
        var hasMoreTransactions = true
        var currentAccountTransactionPage = 0
        var currentSearchPage = 0
        var transactionsPerPage = 10
        var accountTransactions: [AccountTransaction] = []
        var lastTransactions: [AccountTransaction] = []
        var selectedTransaction: AccountTransaction? = nil
        var account: Account

        init(account: Account) {
            self.account = account
        }

        func deleteTransaction(modelContext: ModelContext) {
            isDeleteWarningPresented = false
        }

        func markTransactionAsPending(
            transaction: AccountTransaction, modelContext: ModelContext
        ) {

        }

        func markTransactionAsCleared(
            transaction: AccountTransaction, modelContext: ModelContext
        ) {

        }
    }
}
