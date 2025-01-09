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

    public var acct = Account(name: "Etherpunks Money Register", startingBalance: 0)

    init(generatePreviewData: Bool = false) {
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

        print("-----------------")
        print(Date().toDebugDate())
        print("-----------------")
        print("Database Location: \(self.modelContext.sqliteLocation)")

        if generatePreviewData {
            populateTestData()
        }
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

    func populateTestData() {
        acct = Account(
            id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
            name: "Chase Bank",
            startingBalance: 2062.00,
            currentBalance: 2062.00,
            outstandingBalance: 0.0,
            outstandingItemCount: 0,
            notes: "",
            sortIndex: Int64.max,
            lastBalancedUTC: "2024-09-12T17:40:31.594+0000",
            createdOnUTC: "2024-09-13T17:40:31.594+0000")

        modelContext.insert(acct)

        //Previewer().generatePreviewData(modelContext: modelContext)
    }
}
