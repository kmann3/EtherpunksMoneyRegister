//
//  AccountTransactionsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/3/25.
//

import Foundation
import SwiftUI
import SwiftData

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

        func performAccountTransactionFetch(currentPage: Int = 0, modelContext: ModelContext) {
            let accountId: UUID = account.id

            let predicate = #Predicate<AccountTransaction> { transaction in
                if transaction.accountId == accountId {
                    return true
                } else {
                    return false
                }
            }

            var fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
            fetchDescriptor.fetchLimit = transactionsPerPage
            fetchDescriptor.fetchOffset = self.currentAccountTransactionPage * transactionsPerPage
            fetchDescriptor.sortBy = [.init(\.createdOnUTC, order: .reverse)]

            guard !isLoading && hasMoreTransactions else { return }
            isLoading = true
            DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    DispatchQueue.main.async {
                        if self.lastTransactions == newTransactions {
                            self.hasMoreTransactions = false
                            self.isLoading = false
                            debugPrint("End of list")
                        } else {
                            self.accountTransactions.append(contentsOf: newTransactions)
                            self.lastTransactions = newTransactions
                            self.isLoading = false
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error fetching transactions: \(error.localizedDescription)")
                        self.isLoading = false
                    }
                }
            }
        }

        func fetchAccountTransactionsIfNecessary(transaction: AccountTransaction, modelContext: ModelContext) {
            if let lastTransaction = accountTransactions.last, lastTransaction == transaction {
                debugPrint("More refresh")
                currentAccountTransactionPage += 1
                performAccountTransactionFetch(modelContext: modelContext)
            }
        }

        func deleteTransaction(modelContext: ModelContext) {
            isDeleteWarningPresented = false
        }

        func markTransactionAsPending(transaction: AccountTransaction, modelContext: ModelContext) {

        }

        func markTransactionAsCleared(transaction: AccountTransaction, modelContext: ModelContext) {

        }
    }
}
