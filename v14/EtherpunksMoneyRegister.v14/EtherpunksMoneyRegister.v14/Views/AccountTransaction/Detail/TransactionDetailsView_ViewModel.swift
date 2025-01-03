//
//  TransactionDetailsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/3/25.
//

import Foundation
import SwiftUI
import SwiftData

extension TransactionDetailsView {
    @Observable
    class ViewModel {
        var account: Account?
        var recurringTransaction: RecurringTransaction? = nil
        var recurringGroup: RecurringGroup? = nil
        var transactionFiles: [TransactionFile] = []
        var url: URL?
        var transaction: AccountTransaction

        init(transaction: AccountTransaction) {
            self.transaction = transaction
        }

        func loadData(modelContext: ModelContext) {
            let transactionID = transaction.id

            var fetchDescriptor = FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> { $0.id == transactionID
                })
            fetchDescriptor.fetchLimit = 1
            fetchDescriptor.relationshipKeyPathsForPrefetching = [\.account]
            fetchDescriptor.relationshipKeyPathsForPrefetching = [\.recurringTransaction]
            //        fetchDescriptor.relationshipKeyPathsForPrefetching = [\.recurringTransaction?.recurringGroup]

            let query = try! modelContext.fetch(fetchDescriptor)
            self.account = query.first!.account!
            self.recurringTransaction = query.first!.recurringTransaction
            self.recurringGroup = query.first!.recurringTransaction?.recurringGroup

        }
        func addNewDocument() {}

        func addNewPhoto() {}
    }
}
