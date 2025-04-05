//
//  TagDetailViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/12/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagDetailView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var tag: TransactionTag

        var transactions: [AccountTransaction] = []
        var recurringTransactions: [RecurringTransaction] = []
        var lastUsed: Date?
        var itemCount: Int = 0

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tag: TransactionTag) {
            self.dataSource = dataSource
            self.tag = tag

            let foo = dataSource.fetchTagItemData(tag)
            self.transactions = foo.transactions
            self.recurringTransactions = foo.recurringTransactions
            self.lastUsed = foo.lastUsed
            self.itemCount = foo.count
        }
    }
}
