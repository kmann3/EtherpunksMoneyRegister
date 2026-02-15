//
//  AccountDetailView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

extension AccountDetailView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource

        var account: Account

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account) {
            self.dataSource = dataSource
            self.account = account
        }
    }
}
