//
//  AccountEditViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 4/5/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountEditView {
    @MainActor
    @Observable
    class ViewModel: ObservableObject {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var account: Account
        var name: String
        var startingBalance: Decimal
        var notes: String

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, _ account: Account) {
            self.dataSource = dataSource
            self.account = account
            name = account.name
            startingBalance = account.startingBalance
            notes = account.notes
        }

        func save() {
            fatalError("Not yet implemented")
            let newBalance = self.startingBalance
//            if newBalance == nil {
//                fatalError("Cannot convert starting balance '\(self.startingBalance)' to decimal")
//            }

            let origBalance = self.account.startingBalance
            self.account.startingBalance = newBalance
            self.account.name = self.name
            self.account.notes = self.notes
            self.dataSource.updateAccount(self.account, origBalance: origBalance)
        }
    }
}
