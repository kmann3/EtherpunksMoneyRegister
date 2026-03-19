//
//  RecurringTransaction_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/19/26.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringTransactionListView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource
        
        var recurringTransactionList: [RecurringTransaction] = []
        
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.recurringTransactionList = self.dataSource.fetchAllRecurringTransactions()
        }
    }
}
