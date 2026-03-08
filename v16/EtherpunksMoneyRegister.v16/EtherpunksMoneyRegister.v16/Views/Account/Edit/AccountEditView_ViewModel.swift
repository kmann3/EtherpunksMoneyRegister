//
//  AccountEditView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/8/26.
//

import Combine
import Foundation

extension AccountEditView {
    @MainActor
    class ViewModel : ObservableObject {
        private let dataSource: MoneyDataSource

        var account: Account
        var isNewAccount: Bool = false
        
        @Published var draft: AccountDraft

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, account: Account, isNewAccount: Bool) {
            self.dataSource = dataSource

            self.account = account
            self.isNewAccount = isNewAccount
            self.draft = AccountDraft(account: account)
        }
    }
}
