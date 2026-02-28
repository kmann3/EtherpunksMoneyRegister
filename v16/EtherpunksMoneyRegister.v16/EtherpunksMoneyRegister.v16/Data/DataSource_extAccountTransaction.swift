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
    
    func updateTransactionFile(tran: AccountTransaction, origAccount: Account, origAmount: Decimal, files: [TransactionFile], filesDidChange: Bool) {
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
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            predicate: #Predicate<AccountTransaction> { $0.accountId == oldAccountId && $0.createdOnUTC >= tranCreatedOnUTC },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse),
                                SortDescriptor(\AccountTransaction.name, order: .forward)
                            ]
                        )

                        let results = try modelContext.fetch(descriptor)

                        for transaction in results {
                            transaction.balance = transaction.balance! + origAmount
                        }
                        
                        origAccount.currentBalance = origAccount.currentBalance + origAmount
                        
                    } catch {
                        throw error
                    }

                    // Next update the new account's subsequent transactions
                    do {
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC > tranCreatedOnUTC },
                            sortBy: [
                                SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse),
                                SortDescriptor(\AccountTransaction.name, order: .forward)
                            ]
                        )

                        let results = try modelContext.fetch(descriptor)
                        for transaction in results {
                            transaction.balance = transaction.balance! + origAmount
                        }
                        
                        tran.account.currentBalance = tran.account.currentBalance + tran.amount
                    } catch {
                        throw error
                    }

                } else if tran.amount != origAmount {
                    // If only the amount changed, you may need to cascade balance adjustments here.
                    // Placeholder for amount-change-only logic.
                    
                    do {
                        let descriptor = FetchDescriptor<AccountTransaction>(
                            predicate: #Predicate<AccountTransaction> { $0.accountId == newAccountId && $0.createdOnUTC > tranCreatedOnUTC },
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

