//
//  Dashboard_ReserveTransactionsDialogViewModel.swift.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import Foundation
import Foundation
import SwiftData
import SwiftUI

extension Dashboard_ReserveDebitTransactionDialogView {

    @MainActor
    @Observable
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveTransaction: RecurringTransaction

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, transactionToReserve: RecurringTransaction) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reserveTransaction = transactionToReserve
        }
    }
}
