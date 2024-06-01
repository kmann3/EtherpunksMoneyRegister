//
//  IncrementalTransactionListViewModel.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/1/24.
//

// Eventually this will be needed once there are a lot of transactions to load but right now this seems to be giving XCode grief.

import SwiftUI
import SwiftData

class IncrementalTransactionViewModel: ObservableObject {
    @Environment(\.modelContext) var modelContext
    @Published var transactions: [AccountTransaction] = []
    @Published var isLoading = false
    private var sortDescriptor: [SortDescriptor<AccountTransaction>]
    private var currentPage = 0
    private let transactionsPerPage = 20
    private var account: Account


    init(sortDescriptor: [SortDescriptor<AccountTransaction>], account: Account) {
        self.sortDescriptor = sortDescriptor
        self.account = account
        loadMoreTransactions()
    }

    func loadMoreTransactions() {
        guard !isLoading else { return }
        isLoading = true

        DispatchQueue.global().async {
            let newTransactions = self.fetchTransactions(offset: self.currentPage * self.transactionsPerPage, limit: self.transactionsPerPage, sortDescriptor: self.sortDescriptor)
            DispatchQueue.main.async {
                self.transactions.append(contentsOf: newTransactions)
                self.currentPage += 1
                self.isLoading = false
            }
        }
    }
    
    func fetchTransactions(offset: Int, limit: Int, sortDescriptor: [SortDescriptor<AccountTransaction>]) -> [AccountTransaction] {
        var fetchDescriptor = FetchDescriptor<AccountTransaction>(sortBy: sortDescriptor)
        fetchDescriptor.fetchOffset = offset
        fetchDescriptor.fetchLimit = limit
        fetchDescriptor.relationshipKeyPathsForPrefetching = [\.tags, \.fileCount]
//        fetchDescriptor.predicate = #Predicate<AccountTransaction> { transaction in
//            //transaction.account == account
//            transaction.account.name.localizedStandardContains("Amegy")
//            //transaction.amount > 0
//        }
        
        do {
            let transactions = try modelContext.fetch(fetchDescriptor)
            return transactions
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    }
}
