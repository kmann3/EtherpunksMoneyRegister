//
//  Dashboard_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import Foundation
import SwiftData
import SwiftUI

extension DashboardView {
    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var pendingTransactions: [AccountTransaction]
        var reservedTransactions: [AccountTransaction]

        var upcomingCreditRecurringTransactions: [RecurringTransaction]
        var upcomingNonGroupDebitRecurringTransactions: [RecurringTransaction]
        var upcomingRecurringGroups: [RecurringGroup] = []
        
        var userPrefs: UserPrefs

        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            upcomingNonGroupDebitRecurringTransactions = dataSource.fetchUpcomingRecurringNonGroupDebits()
            upcomingCreditRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .credit)
            upcomingRecurringGroups = dataSource.fetchUpcomingRecurringGroups()
            userPrefs = dataSource.fetchUserPrefs()
        }

        func refreshScreen() {
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            accounts = dataSource.fetchAccounts()
        }
    }
}
