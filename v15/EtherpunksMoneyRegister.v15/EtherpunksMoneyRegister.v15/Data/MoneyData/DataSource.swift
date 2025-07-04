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

    public static let shema = Schema([
        Account.self,
        AccountTransaction.self,
        RecurringGroup.self,
        RecurringTransaction.self,
        TransactionFile.self,
        TransactionTag.self
    ])

#if DEBUG
    public let previewer: Previewer
#endif

    init() {
        self.modelContainer = {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: MoneyDataSource.shema, configurations: [config])
            } catch {
                fatalError("fatal error: Could not create ModelContainer: \(error)")
            }
        }()

        self.modelContext = modelContainer.mainContext

#if DEBUG
        print("-----------------")
        print(Date().toDebugDate())
        print("-----------------")
        print("Database Location: \(modelContext.sqliteLocation)")
        print("-----------------")

        do {
            try modelContext.delete(model: Account.self)
            try modelContext.delete(model: AccountTransaction.self)
            try modelContext.delete(model: RecurringGroup.self)
            try modelContext.delete(model: RecurringTransaction.self)
            try modelContext.delete(model: TransactionFile.self)
            try modelContext.delete(model: TransactionTag.self)
        } catch {
            print("Failed to clear database. Err: \(error)")
        }

        self.previewer = Previewer()
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

    func fetchAccountTransactions(account: Account) -> [AccountTransaction] {
        let id = account.id
        do {
            return try modelContext.fetch(FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { transaction in
                    if transaction.accountId == id {
                        return true
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

    func fetchAllRecurringGroups() -> [RecurringGroup] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringGroup>(
                sortBy: [SortDescriptor(\RecurringGroup.name, order: .forward)]
            ))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchAllRecurringTransactions() -> [RecurringTransaction] {
        do {
            return try modelContext.fetch(FetchDescriptor<RecurringTransaction>(
                sortBy: [SortDescriptor(\RecurringTransaction.name, order: .forward)]
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
                },
                sortBy: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
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

    func fetchTagItemData(_ transactionTag: TransactionTag) -> (count: Int, lastUsed: Date?, transactions: [AccountTransaction], recurringTransactions: [RecurringTransaction]) {
        let tagId = transactionTag.id

        var fetchDescriptor: FetchDescriptor<TransactionTag> {
            var descriptor = FetchDescriptor<TransactionTag>(
                predicate: #Predicate<TransactionTag> {
                    $0.id == tagId
                }
            )
            descriptor.fetchLimit = 1
            descriptor.relationshipKeyPathsForPrefetching = [
                \.accountTransactions,
                \.recurringTransactions
            ]
            return descriptor
        }

        let query = try! modelContext.fetch(fetchDescriptor)

        return (query.first?.accountTransactions?.count ?? 0,
                query.first?.createdOnUTC ?? nil,
                query.first?.accountTransactions?.sorted(by: { $0.createdOnUTC > $1.createdOnUTC }) ?? [],
                query.first?.recurringTransactions?.sorted(by: { $0.name < $1.name }) ?? [])
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
            fatalError(error.localizedDescription)
        }
    }

//    func reserveCreditDeposit(recurringTransaction: RecurringTransaction, newTransaction: AccountTransaction) {
//        try? modelContext.transaction {
//            let account = newTransaction.account
//            newTransaction.balance = account.currentBalance + newTransaction.amount
//
//            if newTransaction.clearedOnUTC == nil {
//                account.outstandingBalance += newTransaction.amount
//                account.outstandingItemCount += 1
//            }
//
//            account.transactionCount += 1
//            account.currentBalance = newTransaction.balance!
//
//            do {
//                try recurringTransaction.BumpNextDueDate()
//                modelContext.insert(newTransaction)
//                try modelContext.save()
//            } catch {
//                print(error)
//                modelContext.rollback()
//            }
//        }
//    }
//
//    func reserveDebitGroup(group: RecurringGroup, newTransactions: [AccountTransaction]) {
//        try? modelContext.transaction {
//
//            group.recurringTransactions!.forEach { item in
//                try? item.BumpNextDueDate()
//            }
//
//            do {
//                newTransactions.forEach {
//                    let transactionAccount = $0.account
//                    transactionAccount.currentBalance += $0.amount
//                    transactionAccount.outstandingBalance += $0.amount
//                    transactionAccount.outstandingItemCount += 1
//                    transactionAccount.transactionCount += 1
//                    $0.balance = transactionAccount.currentBalance
//
//                    modelContext.insert($0)
//                }
//                try modelContext.save()
//            } catch {
//                print(error)
//                modelContext.rollback()
//            }
//        }
//    }
//
//    func reserveDebitTransaction(recurringTransaction: RecurringTransaction, newTransaction: AccountTransaction) {
//        try? modelContext.transaction {
//            let account = newTransaction.account
//            newTransaction.balance = account.currentBalance + newTransaction.amount
//
//            if newTransaction.clearedOnUTC == nil {
//                account.outstandingBalance += newTransaction.amount
//                account.outstandingItemCount += 1
//            }
//
//            account.transactionCount += 1
//            account.currentBalance = newTransaction.balance!
//
//            do {
//                try recurringTransaction.BumpNextDueDate()
//                modelContext.insert(newTransaction)
//                try modelContext.save()
//            } catch {
//                print(error)
//                modelContext.rollback()
//            }
//        }
//    }
//
//    func reserveTransactions(groups: [RecurringGroup], transactions: [RecurringTransaction], account: Account) {
//        try? modelContext.transaction {
//
//            if groups.count > 0 {
//                groups.forEach { item in
//                    if item.recurringTransactions != nil {
//                        item.recurringTransactions!.forEach { transaction in
//                            account.currentBalance += transaction.amount
//                            account.outstandingBalance += transaction.amount
//                            account.outstandingItemCount += 1
//                            account.transactionCount += 1
//
//                            modelContext.insert(AccountTransaction(recurringTransaction: transaction))
//
//                            try? transaction.BumpNextDueDate()
//                        }
//                    }
//                }
//            }
//
//            transactions.forEach { item in
//                account.currentBalance += item.amount
//                account.outstandingBalance += item.amount
//                account.outstandingItemCount += 1
//                account.transactionCount += 1
//
//                modelContext.insert(AccountTransaction(recurringTransaction: item))
//
//                try? item.BumpNextDueDate()
//            }
//
//            do {
//                try modelContext.save()
//            } catch {
//                print(error)
//                modelContext.rollback()
//            }
//        }
//    }

    func reserveRecurringTransactions(recurringTransactions: [ReserveGroupView.AccountTransactionQueueItem]) {
        try? modelContext.transaction {
            for item in recurringTransactions {
                item.accountTransaction.VerifySignage()
                item.accountTransaction.createdOnUTC = Date()

                switch item.action {
                case .enable:
                    item.accountTransaction.account.currentBalance += item.recurringTransaction.amount
                    item.accountTransaction.account.outstandingBalance += item.recurringTransaction.amount
                    item.accountTransaction.account.outstandingItemCount += 1
                    item.accountTransaction.account.transactionCount += 1

                    item.accountTransaction.transactionType = item.recurringTransaction.transactionType
                    item.accountTransaction.recurringTransaction = item.recurringTransaction
                    item.accountTransaction.balance! += item.recurringTransaction.amount
                    item.accountTransaction.VerifySignage()
                    item.accountTransaction.createdOnUTC = Date()

                    modelContext.insert(item.accountTransaction)
                case .ignore:
                    debugPrint("Ignoring: \(item.accountTransaction.name)")
                    item.accountTransaction.recurringTransaction = nil
                    modelContext.delete(item.accountTransaction)
                case .skip:
                    debugPrint("Skipping: \(item.accountTransaction.name)")
                    item.accountTransaction.recurringTransaction = nil
                    modelContext.delete(item.accountTransaction)
                    try? item.recurringTransaction.BumpNextDueDate()
                }
            }

            do {
                try modelContext.save()
            } catch {
                print(error)
                modelContext.rollback()
            }
        }
    }

    func updateAccount(_ account: Account, origBalance: Decimal) {
        do {
            try modelContext.transaction {
                // Check if starting amount changed, and recalculate all transactions if needed
                if origBalance != account.startingBalance {
                    // Example: compute difference and apply to transactions
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
                
                // Save happens automatically if no error is thrown
            }
        } catch {
            fatalError(error.localizedDescription)
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
