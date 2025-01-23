//
//  Dashboard_FullSummaryView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/22/25.
//

import Foundation
import Foundation
import SwiftData
import SwiftUI

extension Dashboard_FullSummaryView {

    @MainActor
    @Observable
    class ViewModel : ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var availableBalance: Decimal = 0
        var outstandingItemCount: Int64 = 0
        var outstandingAmount: Decimal = 0
        var accounts: [Account] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, accounts: [Account]) {
            self.dataSource = dataSource
            self.accounts = accounts

            accounts.forEach { account in
                outstandingAmount = outstandingAmount + account.outstandingBalance
                outstandingItemCount += account.outstandingItemCount
                availableBalance = availableBalance + account.currentBalance
            }
        }
    }
}
