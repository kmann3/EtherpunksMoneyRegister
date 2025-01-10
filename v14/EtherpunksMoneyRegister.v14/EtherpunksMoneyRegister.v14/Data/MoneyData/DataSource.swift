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
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

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

        if query.count > 0 {
            return (query.first!.accountTransactions?.count ?? 0, query.first?.createdOnUTC ?? nil)
        } else {
            return (0, nil)
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

    func reserveTransactions(_ transactions: [RecurringTransaction], account: Account) {
        try? modelContext.transaction {
            transactions.forEach { item in
                account.currentBalance += item.amount
                account.outstandingBalance += item.amount
                account.outstandingItemCount += 1
                account.transactionCount += 1

                modelContext.insert(AccountTransaction(recurringTransaction: item, account: account))

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
