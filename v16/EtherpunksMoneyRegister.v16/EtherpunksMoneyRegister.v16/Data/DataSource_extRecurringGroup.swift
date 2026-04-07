//
//  DataSource_extRecurringGroup.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    func fetchAllRecurringGroups() -> [RecurringGroup] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringGroup>(
                sortBy: [SortDescriptor(\RecurringGroup.name, order: .forward)]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchUpcomingRecurringGroups() -> [RecurringGroup] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringGroup>(
                sortBy: [
                    SortDescriptor(\RecurringGroup.name)
                ]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func insertRecurringGroup(_ recurringGroup: RecurringGroup) {
        do {
            modelContext.insert(recurringGroup)
            try modelContext.save()
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
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
                DLog(error.localizedDescription)
                modelContext.rollback()
            }
        }
    }
    
    func updateRecurringGroup(_ group: RecurringGroup) {
        do {
            try modelContext.save()
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
}
