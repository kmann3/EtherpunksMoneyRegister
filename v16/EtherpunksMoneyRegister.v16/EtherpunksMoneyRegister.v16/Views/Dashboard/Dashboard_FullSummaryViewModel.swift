//
//  Dashboard_FullSummaryView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/22/25.
//

import Foundation
import SwiftData
import SwiftUI

extension Dashboard_FullSummaryView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var availableBalance: Decimal = 0
        var outstandingItemCount: Int64 = 0
        var outstandingAmount: Decimal = 0
        var accounts: [Account] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, accounts: [Account]) {
            self.dataSource = dataSource
            self.accounts = accounts

            for account in accounts {
                outstandingAmount = outstandingAmount + account.outstandingBalance
                outstandingItemCount += account.outstandingItemCount
                availableBalance = availableBalance + account.currentBalance
            }
        }
    }
}
