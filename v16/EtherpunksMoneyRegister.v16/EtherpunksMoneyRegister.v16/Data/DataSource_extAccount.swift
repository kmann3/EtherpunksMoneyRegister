//
//  DataSource_extAccount.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    
    func fetchAccounts() -> [Account] {
        do {
            return try modelContext.fetch(FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchAccountsAsync() async -> [Account] {
        do {
            return try modelContext.fetch(FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateAccount(_ account: Account, origBalance: Decimal) {
        do {
            try modelContext.transaction {
                // Check if starting amount changed, and recalculate all transactions if needed
                if origBalance != account.startingBalance {
                    let difference = account.startingBalance - origBalance
                    
                    // Fetch all transactions for the account
                    let accountId = account.id
                    let transactions = try modelContext.fetch(FetchDescriptor<AccountTransaction>(
                        predicate: #Predicate<AccountTransaction> { $0.accountId == accountId },
                        sortBy: [SortDescriptor(\.createdOnUTC)]
                    ))
                    
                    // Adjust each transaction balance accordingly
                    for transaction in transactions {
                        transaction.balance? += difference
                    }
                }
                
                // Save happens automatically if no error is thrown ; This feels like I should manually save still.
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
