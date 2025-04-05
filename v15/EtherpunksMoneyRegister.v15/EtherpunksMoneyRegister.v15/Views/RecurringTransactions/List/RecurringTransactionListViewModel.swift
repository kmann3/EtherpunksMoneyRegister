//
//  RecurringTransactionListViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringTransactionListView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var recurringTransactions: [RecurringTransaction] = []
        var selectedRecurringTransaction: RecurringTransaction?

        init(_ dataSource: MoneyDataSource = MoneyDataSource.shared, selectedRecurringTransaction: RecurringTransaction? = nil) {
            self.dataSource = dataSource
            self.selectedRecurringTransaction = selectedRecurringTransaction

            self.recurringTransactions = self.dataSource.fetchAllRecurringTransactions()
        }
    }
}
