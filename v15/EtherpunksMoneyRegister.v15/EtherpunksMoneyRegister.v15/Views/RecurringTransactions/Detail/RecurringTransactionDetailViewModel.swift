//
//  RecurringTransactionDetailViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringTransactionDetailView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var recTran: RecurringTransaction

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, recTran: RecurringTransaction) {
            self.dataSource = dataSource
            self.recTran = recTran
        }
    }
}
