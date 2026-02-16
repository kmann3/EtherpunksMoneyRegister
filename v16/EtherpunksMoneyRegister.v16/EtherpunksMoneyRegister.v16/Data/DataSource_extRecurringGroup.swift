//
//  DataSource_extRecurringGroup.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    func reserveTransactions(groups: [RecurringGroup], transactions: [RecurringTransaction], account: Account) {
        // TODO: This method may not be completed. I did this months ago and I can't remember where it is in the process.
        try? modelContext.transaction {

            if groups.count > 0 {
                groups.forEach { item in
                    if item.recurringTransactions != nil {
                        item.recurringTransactions!.forEach { transaction in
                            account.currentBalance += transaction.amount
                            account.outstandingBalance += transaction.amount
                            account.outstandingItemCount += 1
                            account.transactionCount += 1

                            modelContext.insert(AccountTransaction(recurringTransaction: transaction))

                            try? transaction.BumpNextDueDate()
                        }
                    }
                }
            }

            transactions.forEach { item in
                account.currentBalance += item.amount
                account.outstandingBalance += item.amount
                account.outstandingItemCount += 1
                account.transactionCount += 1

                modelContext.insert(AccountTransaction(recurringTransaction: item))

                try? item.BumpNextDueDate()
            }

            do {
                try modelContext.save()
            } catch {
                print(error)
                modelContext.rollback()
            }
        }
    }
}
