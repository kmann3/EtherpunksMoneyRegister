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

extension Dashboard_ReserveDebitGroupDialogView {

    @MainActor
    @Observable
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveGroup: RecurringGroup
        var selectedAccount: Account = Account()

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, groupToReserve: RecurringGroup) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reserveGroup = groupToReserve
            selectedAccount = reserveGroup.recurringTransactions!.first!.defaultAccount ?? accounts.first!
        }
    }
}
