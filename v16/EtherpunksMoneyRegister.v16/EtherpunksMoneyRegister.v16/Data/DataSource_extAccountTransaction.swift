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
        let limit = 50 // TODO: We have an artificially low amount so we can test the loading of more transactions later

        do {
            var descriptor = FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { $0.accountId == id },
                sortBy: [
                    SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse),
                    SortDescriptor(\AccountTransaction.name, order: .forward)
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
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }

    func fetchAllPendingTransactions() -> [AccountTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { $0.clearedOnUTC == nil && $0.pendingOnUTC != nil },
                sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchAllReservedTransactions() -> [AccountTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { transaction in
                    if transaction.clearedOnUTC == nil {
                        if transaction.pendingOnUTC == nil {
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
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTransactionFiles(transaction: AccountTransaction) -> [TransactionFile] {
        let id = transaction.id
        do {
            return try modelContext.fetch(FetchDescriptor<TransactionFile>(
                predicate: #Predicate<TransactionFile> { $0.transactionId == id },

                sortBy: [SortDescriptor(\TransactionFile.createdOnUTC, order: .reverse)]

            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func insertAccountTransaction(transaction: AccountTransaction) {
        do {
            modelContext.insert(transaction)
            if transaction.isPending || transaction.isReserved {
                transaction.account.outstandingItemCount = transaction.account.outstandingItemCount  + 1
                transaction.account.outstandingBalance = transaction.account.outstandingBalance + transaction.amount
            }
            transaction.account.currentBalance = transaction.account.currentBalance + transaction.amount
            try modelContext.save()
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func recalculateAccountBalance(account: Account) {
        // TODO: Add code for letting user pick a starting point instead of recalculating the entire account?
        do {
            try modelContext.transaction {
                let accountId = account.id
                
                var balance: Decimal = account.startingBalance
                var outstandingBalance: Decimal = 0
                var outstandingItemCount: Int64 = 0
                
                let descriptor = FetchDescriptor<AccountTransaction>(
                    predicate: #Predicate<AccountTransaction> { $0.accountId == accountId },
                    sortBy: [
                        SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                        SortDescriptor(\AccountTransaction.name, order: .forward)
                    ]
                )
                
                let results = try modelContext.fetch(descriptor)

                for transaction in results {
                    balance = balance + transaction.amount
                    
                    if (transaction.isPending || transaction.isReserved) {
                        outstandingBalance = outstandingBalance + transaction.amount
                        outstandingItemCount = outstandingItemCount + 1
                    }
                }
                
                account.currentBalance = balance
                account.outstandingBalance = outstandingBalance
                account.outstandingItemCount = outstandingItemCount
            }
            
            try modelContext.save()
        }  catch {
            modelContext.rollback()
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func updateAccountTransaction(transaction: AccountTransaction, origAccount: Account, origAmount: Decimal, files: [TransactionFile], filesDidChange: Bool) {
        do {
            let transactionId = transaction.id
            let newAccountId = transaction.accountId
            let oldAccountId = origAccount.id

            let tranCreatedOnUTC = transaction.createdOnUTC
            try modelContext.transaction {
                // If the account changed, we need to adjust postings on both the original and new accounts
                if transaction.account != origAccount {
                    // TODO: Take care of pending / expecting account balance
                    // First update the old account's subsequent transactions
                    do {
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == oldAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != transactionId },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                                SortDescriptor(\AccountTransaction.name, order: .forward)
                            ]
                        )

                        let results = try modelContext.fetch(descriptor)

                        for transaction in results {
                            transaction.balance = transaction.balance! + origAmount // Since the transaction amount could have changed as well as the account being changed - just use origAmount
                        }
                        
                        origAccount.currentBalance = origAccount.currentBalance - origAmount
                        
                        // Now we edit the outstanding
                        // TODO: What if it was previously oustanding but is no longer?
                        if (transaction.isPending || transaction.isReserved) {
                            origAccount.outstandingItemCount = origAccount.outstandingItemCount  - 1
                            origAccount.currentBalance = origAccount.currentBalance - origAmount
                        }
                        
                    } catch {
                        throw error
                    }

                    // Next update the new account's subsequent transactions
                    do {
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != transactionId },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                                SortDescriptor(\AccountTransaction.name, order: .forward)
                            ]
                        )

                        let results = try modelContext.fetch(descriptor)
                        for t in results {
                            t.balance = t.balance! + transaction.amount // Since the new transaction might have changed the amount then use it instead of origAmount
                        }
                        
                        transaction.account.currentBalance = transaction.account.currentBalance + transaction.amount
                        
                        // Now we edit the outstanding
                        if (transaction.isPending || transaction.isReserved) {
                            transaction.account.outstandingItemCount = transaction.account.outstandingItemCount  + 1
                            transaction.account.currentBalance = transaction.account.currentBalance + origAmount
                        }

                    } catch {
                        throw error
                    }

                } else if transaction.amount != origAmount {
                    // If only the amount changed, you may need to cascade balance adjustments here.
                    // Placeholder for amount-change-only logic.
                    
                    do {
                        let oldTransactionId = transaction.id
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != oldTransactionId },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                                SortDescriptor(\AccountTransaction.name, order: .forward) // This should never be hit but just in case, let's just be consistent with adding a name filter
                            ]
                        )
                        
                        let difference: Decimal = transaction.amount - origAmount
                        
                        DLog("Update transaction file with difference: \(difference) from old value: \(origAmount) to new value: \(transaction.amount)")

                        let results = try modelContext.fetch(descriptor)
                        for transaction in results {
                            transaction.balance = transaction.balance! + difference
                        }
                        
                        transaction.account.currentBalance = transaction.account.currentBalance + difference
                        
                        // Now we edit the outstanding
                        if (transaction.isPending || transaction.isReserved) {
                            transaction.account.currentBalance = transaction.account.currentBalance + difference
                        }
                    } catch {
                        throw error
                    }
                }

                // TODO: Handle files efficiently without re-saving large payloads every time.

                // Persist all changes as a single atomic operation
                try modelContext.save()
            }
        } catch {
            modelContext.rollback()
            DLog(error.localizedDescription)
            fatalError("Failed to save transaction changes (rolled back): \(error)")
        }
    }
}

