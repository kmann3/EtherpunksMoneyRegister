//
//  ContentView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/11/26.
//

import Swift
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]

        @MainActor
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.accounts = dataSource.fetchAccounts()
        }
    }
}
