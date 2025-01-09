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
        var modelContext: ModelContext? = nil
        init(account: Account) {
            self.account = account
//            let id = viewModel.account.id
//            self._accountTransactions = Query(filter: #Predicate {
//                $0.accountId == id
//            }, sort: \.createdOnUTC, order: .reverse)
//
//            self._accountDetails = Query(filter: #Predicate<Account> {
//                $0.id == id
//            })
//
//            if(accountDetails.isEmpty) {
//                debugPrint( "AccountDetails is empty")
//            } else {
//                viewModel.account = accountDetails.first!
//            }
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
