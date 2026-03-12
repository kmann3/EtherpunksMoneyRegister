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
        
        func save() {
            let origBalance = account.startingBalance
            let account = self.account
            account.name = draft.name
            account.notes = draft.notes
            account.lastBalancedUTC = draft.lastBalancedUTC
            account.startingBalance = draft.startingBalance
            if self.isNewAccount {
                self.dataSource.insertAccount(account)
            } else {
                self.dataSource.updateAccount(account, origBalance: origBalance)
            }
        }
    }
}
