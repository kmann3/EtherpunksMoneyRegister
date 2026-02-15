//
//  DataSource_extAccountTransaction.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    func fetchAccountTransactions(account: Account) -> (transactions: [AccountTransaction], hasMoreTransactions: Bool) {
        let id = account.id
        let limit = 5 // TODO: We have an artificially low amount so we can test the loading of more transactions later

        do {
            var descriptor = FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { $0.accountId == id },
                sortBy: [
                    SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse),
                    SortDescriptor(\AccountTransaction.id, order: .forward)
                ]
            )
            descriptor.fetchLimit = limit + 1

            var results = try modelContext.fetch(descriptor)

            let hasMore = results.count > limit
            if hasMore {
                results.removeLast()
            }

            return (results, hasMore ? true : false)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchAllPendingTransactions() -> [AccountTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { transaction in
                    if transaction.clearedOnUTC == nil {
                        if transaction.pendingOnUTC != nil {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                },
                sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTransactionFiles(tran: AccountTransaction) -> [TransactionFile] {
        let id = tran.id
        do {
            return try modelContext.fetch(FetchDescriptor<TransactionFile>(
                predicate: #Predicate<TransactionFile> {
                    if $0.transactionId == id {
                        return true
                    } else {
                        return false
                    }
                },

                sortBy: [SortDescriptor(\TransactionFile.createdOnUTC, order: .reverse)]

            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
