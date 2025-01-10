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

extension Dashboard_ReserveTransactionsDialogView {

    @MainActor
    @Observable
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveList: [RecurringTransaction]


        init(dataSource: MoneyDataSource = MoneyDataSource.shared, listToReserve: [RecurringTransaction]) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reserveList = listToReserve.sorted(by: {$0.name < $1.name })
        }
    }
}
