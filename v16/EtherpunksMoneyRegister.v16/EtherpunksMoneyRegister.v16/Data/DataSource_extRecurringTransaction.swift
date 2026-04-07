//
//  DataSource_extRecurringGroup.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    func fetchAllRecurringTransactions() -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                sortBy: [SortDescriptor(\RecurringTransaction.name, order: .forward)]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchUpcomingRecurringNonGroupDebits() -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                predicate: #Predicate<RecurringTransaction> {
                    if $0.amount < 0, $0.recurringGroup == nil {
                        return true
                    } else {
                        return false
                    }
                },
                sortBy: [
                    SortDescriptor(\RecurringTransaction.nextDueDate),
                    SortDescriptor(\RecurringTransaction.name)
                ]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }

    func fetchUpcomingRecurringTransactions(transactionType: TransactionType) -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                predicate: RecurringTransaction.transactionTypeFilter(type: transactionType),
                sortBy: [
                    SortDescriptor(\RecurringTransaction.nextDueDate),
                    SortDescriptor(\RecurringTransaction.name)
                ]
            ))
        } catch {
            DLog(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
}
