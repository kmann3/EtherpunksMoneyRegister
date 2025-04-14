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
        var startingBalance: String
        var notes: String

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, _ account: Account) {
            self.dataSource = dataSource
            self.account = account
            name = account.name
            startingBalance = account.startingBalance.formatted()
            notes = account.notes
        }

        func save() {
            
        }
    }
}
