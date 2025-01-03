//
//  AccountTransactionsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/3/25.
//

import Foundation
import SwiftUI
import SwiftData

extension AccountTransactionsView {
    @Observable
    class ViewModel {
        var searchText = ""
        var isLoading = false
        var hasMoreTransactions = true
        var currentAccountTransactionPage = 0
        var currentSearchPage = 0
        var transactionsPerPage = 10
        var accountTransactions: [AccountTransaction] = []
        var lastTransactions: [AccountTransaction] = []
        var account: Account

        init(account: Account) {
            
        }
    }
}
