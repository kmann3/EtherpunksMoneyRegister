//
//  DataSource_extTag.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
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
    
    func updateTag(_ tag: TransactionTag) {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
