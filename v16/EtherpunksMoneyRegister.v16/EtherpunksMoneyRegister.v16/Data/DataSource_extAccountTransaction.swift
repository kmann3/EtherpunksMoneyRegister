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
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTransactionFiles(tran: AccountTransaction) -> [TransactionFile] {
        let id = tran.id
        do {
            return try modelContext.fetch(FetchDescriptor<TransactionFile>(
                predicate: #Predicate<TransactionFile> { $0.transactionId == id },

                sortBy: [SortDescriptor(\TransactionFile.createdOnUTC, order: .reverse)]

            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func recalculateAccountBalance(account: Account) {
        // TODO: Add code for letting user pick a starting point instead of recalculating the entire account?
        do {
            try modelContext.transaction {
                let accountId = account.id
                
                var balance = account.startingBalance
                var outstandingBalance = 0
                var outstandingItemCount = 0
                
                let descriptor = FetchDescriptor<AccountTransaction>(
                    predicate: #Predicate<AccountTransaction> { $0.accountId == accountId },
                    sortBy: [
                        SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                        SortDescriptor(\AccountTransaction.name, order: .forward)
                    ]
                )
                
                let results = try modelContext.fetch(descriptor)

                for transaction in results {
                    // TODO: calculate
                }
            }
        }  catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateAccountTransaction(tran: AccountTransaction, origAccount: Account, origAmount: Decimal, files: [TransactionFile], filesDidChange: Bool) {
        do {
            print("Updating transaction")
            //let transactionId = tran.id
            let newAccountId = tran.accountId
            let oldAccountId = origAccount.id
            
            print("New AccountID: \(newAccountId!)")
            print("Old AccountID: \(oldAccountId)")
            let tranCreatedOnUTC = tran.createdOnUTC
            try modelContext.transaction {
                // If the account changed, we need to adjust postings on both the original and new accounts
                if tran.account != origAccount {
                    // TODO: Take care of pending / expecting account balance
                    // First update the old account's subsequent transactions
                    do {
                        let oldTransactionId = tran.id
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == oldAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != oldTransactionId },
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
                        if (tran.isPending || tran.isReserved) {
                            origAccount.outstandingItemCount = origAccount.outstandingItemCount  - 1
                            origAccount.currentBalance = origAccount.currentBalance - origAmount
                        }
                        
                    } catch {
                        throw error
                    }

                    // Next update the new account's subsequent transactions
                    do {
                        let oldTransactionId = tran.id
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != oldTransactionId },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                                SortDescriptor(\AccountTransaction.name, order: .forward)
                            ]
                        )

                        let results = try modelContext.fetch(descriptor)
                        for transaction in results {
                            transaction.balance = transaction.balance! + tran.amount // Since the new transaction might have changed the amount then use it instead of origAmount
                        }
                        
                        tran.account.currentBalance = tran.account.currentBalance + tran.amount
                        
                        // Now we edit the outstanding
                        if (tran.isPending || tran.isReserved) {
                            tran.account.outstandingItemCount = tran.account.outstandingItemCount  + 1
                            tran.account.currentBalance = tran.account.currentBalance + origAmount
                        }

                    } catch {
                        throw error
                    }

                } else if tran.amount != origAmount {
                    // If only the amount changed, you may need to cascade balance adjustments here.
                    // Placeholder for amount-change-only logic.
                    
                    do {
                        let oldTransactionId = tran.id
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            // Use greater than or equal to in case we did a batch create and all the createdOn's are the same
                            // We skip the transactionId so we don't double up
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC >= tranCreatedOnUTC && $0.id != oldTransactionId },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .forward),
                                SortDescriptor(\AccountTransaction.name, order: .forward) // This should never be hit but just in case, let's just be consistent with adding a name filter
                            ]
                        )
                        
                        let difference: Decimal = tran.amount - origAmount
                        
                        print("Update transaction file with difference: \(difference) from old value: \(origAmount) to new value: \(tran.amount)")

                        let results = try modelContext.fetch(descriptor)
                        for transaction in results {
                            transaction.balance = transaction.balance! + difference
                        }
                        
                        tran.account.currentBalance = tran.account.currentBalance + difference
                        
                        // Now we edit the outstanding
                        if (tran.isPending || tran.isReserved) {
                            tran.account.currentBalance = tran.account.currentBalance + difference
                        }
                    } catch {
                        throw error
                    }
                }

                // TODO: Handle files efficiently without re-saving large payloads every time.

                // Persist all changes as a single atomic operation
                try modelContext.save()
                print("Update complete")
            }
        } catch {
            fatalError("Failed to save transaction changes (rolled back): \(error)")
        }
    }
}

