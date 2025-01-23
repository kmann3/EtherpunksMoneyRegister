//
//  DataSource.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class MoneyDataSource: Sendable {
    public let modelContainer: ModelContainer
    public let modelContext: ModelContext

    static let shared = MoneyDataSource()
    static let pathStore = PathStore()

#if DEBUG
    public let previewer: Previewer
#endif

    init() {
        self.modelContainer = {
            let schema = Schema([
                Account.self,
                AccountTransaction.self,
                RecurringGroup.self,
                RecurringTransaction.self,
                TransactionFile.self,
                TransactionTag.self
            ])

            let config = ModelConfiguration(isStoredInMemoryOnly: true)

            do {

                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("fatal error: Could not create ModelContainer: \(error)")
            }
        }()

        self.modelContext = self.modelContainer.mainContext

        #if DEBUG
        print("-----------------")
        print(Date().toDebugDate())
        print("-----------------")
        print("Database Location: \(self.modelContext.sqliteLocation)")
        print("-----------------")

        previewer = Previewer()
        previewer.commitToDb(modelContext)
        #endif
    }

    func createTag(_ tag: TransactionTag) {
        do {
            modelContext.insert(tag)
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func deleteTag(_ tag: TransactionTag) {
        modelContext.delete(tag)
    }

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
                }
                ,sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
                ))
        } catch {
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
                }
                ,sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchAllTags() -> [TransactionTag] {
        do {
            return try modelContext.fetch(FetchDescriptor<TransactionTag>(
                sortBy: [SortDescriptor(\TransactionTag.name)]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchTagItemData(_ transactionTag: TransactionTag) -> (count: Int, lastUsed: Date?) {
        let tagId = transactionTag.id

        var fetchDescriptor: FetchDescriptor<TransactionTag> {
            var descriptor = FetchDescriptor<TransactionTag>(
                predicate: #Predicate<TransactionTag> {
                    $0.id == tagId
                }
            )
            descriptor.fetchLimit = 1
            descriptor.relationshipKeyPathsForPrefetching = [
                \.accountTransactions
            ]
            return descriptor
        }

        let query = try! modelContext.fetch(fetchDescriptor)
        // could use fetchCount and then do a different query to just get the most recent one
        if query.count > 0 {
            return (query.first!.accountTransactions?.count ?? 0, query.first?.createdOnUTC ?? nil)
        } else {
            return (0, nil)
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
            fatalError(error.localizedDescription)
        }
    }

    func fetchUpcomingRecurringNonGroupDebits() -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                predicate: #Predicate<RecurringTransaction> {
                    if $0.amount < 0 && $0.recurringGroup == nil {
                        return true
                    } else {
                        return false
                    }
                }
                ,sortBy: [
                    SortDescriptor(\RecurringTransaction.nextDueDate),
                    SortDescriptor(\RecurringTransaction.name)
                ]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchUpcomingRecurringTransactions(transactionType: TransactionType) -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                predicate: RecurringTransaction.transactionTypeFilter(type: transactionType)
                ,sortBy: [
                    SortDescriptor(\RecurringTransaction.nextDueDate),
                    SortDescriptor(\RecurringTransaction.name)
                ]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func ReserveCreditDeposit(recurringTransaction: RecurringTransaction, newTransaction: AccountTransaction) {
        try? modelContext.transaction {
            let account = newTransaction.account!
            newTransaction.balance = account.currentBalance + newTransaction.amount

            if newTransaction.clearedOnUTC == nil {
                account.outstandingBalance += newTransaction.amount
                account.outstandingItemCount += 1
            }

            account.transactionCount += 1
            account.currentBalance = newTransaction.balance!

            do {
                try recurringTransaction.BumpNextDueDate()
                modelContext.insert(newTransaction)
                try modelContext.save()
            } catch {
                print(error)
                modelContext.rollback()
            }
        }
    }

    func ReserveDebitGroup(group: RecurringGroup, newTransactions: [AccountTransaction]) {
        try? modelContext.transaction {

            group.recurringTransactions!.forEach { item in
                try? item.BumpNextDueDate()
            }

            do {
                newTransactions.forEach {
                    let transactionAccount = $0.account!
                    transactionAccount.currentBalance += $0.amount
                    transactionAccount.outstandingBalance += $0.amount
                    transactionAccount.outstandingItemCount += 1
                    transactionAccount.transactionCount += 1
                    modelContext.insert($0)
                }
                try modelContext.save()
            } catch {
                print(error)
                modelContext.rollback()
            }
        }
    }

    func ReserveDebitTransaction(recurringTransaction: RecurringTransaction, newTransaction: AccountTransaction) {
        try? modelContext.transaction {
            let account = newTransaction.account!
            newTransaction.balance = account.currentBalance + newTransaction.amount

            if newTransaction.clearedOnUTC == nil {
                account.outstandingBalance += newTransaction.amount
                account.outstandingItemCount += 1
            }

            account.transactionCount += 1
            account.currentBalance = newTransaction.balance!

            do {
                try recurringTransaction.BumpNextDueDate()
                modelContext.insert(newTransaction)
                try modelContext.save()
            } catch {
                print(error)
                modelContext.rollback()
            }
        }
    }

    func reserveTransactions(groups: [RecurringGroup], transactions: [RecurringTransaction], account: Account) {
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

    func updateTag(_ tag: TransactionTag) {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
