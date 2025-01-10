//
//  AccountsViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import Foundation

extension AccountsView {

    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var pathStore: PathStore

        var accounts: [Account]

        @MainActor
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            self.accounts = dataSource.fetchAccounts()
        }
    }
}
