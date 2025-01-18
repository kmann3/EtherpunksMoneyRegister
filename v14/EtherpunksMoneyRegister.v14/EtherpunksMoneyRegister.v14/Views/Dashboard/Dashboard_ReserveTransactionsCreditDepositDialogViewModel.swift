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

extension Dashboard_ReserveTransactionsCreditDepositDialogView {

    @MainActor
    @Observable
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var displayAmount: String = ""
        var date: Date? = Date()
        var reserveTransaction: RecurringTransaction

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, transactionToReserve: RecurringTransaction) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reserveTransaction = transactionToReserve
        }
    }
}
