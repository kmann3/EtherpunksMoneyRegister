//
//  DataSource_extAccountTransaction.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData
import CoreData

extension MoneyDataSource {
    func fetchAccountTransactions(account: Account) -> (transactions: [AccountTransaction], remainingTransactionsCount: Int) {
        let id = account.id
        do {
            var descriptor = FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { transaction in
                    if transaction.accountId == id {
                        return true
                    } else {
                        return false
                    }
                },
                sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
            )
            descriptor.fetchLimit = 1000

            let results = try modelContext.fetch(descriptor)
            let totalCountRequest = NSFetchRequest<NSNumber>(entityName: "AccountTransaction")
            totalCountRequest.resultType = .countResultType

            let totalCount = try modelContext.fetchCount(FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { transaction in
                    if transaction.accountId == id {
                        return true
                    } else {
                        return false
                    }
                },
                sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
            ))

            if totalCount > results.count {
                // more records available
                return (results, totalCount-results.count)
            } else {
                // No more records
                return (results, 0)
            }
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
