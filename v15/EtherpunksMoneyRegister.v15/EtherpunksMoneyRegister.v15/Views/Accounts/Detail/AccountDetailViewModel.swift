//
//  AccountDetailViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 4/5/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountDetailView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var account: Account

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account) {
            self.dataSource = dataSource
            self.account = account
        }
    }
}
