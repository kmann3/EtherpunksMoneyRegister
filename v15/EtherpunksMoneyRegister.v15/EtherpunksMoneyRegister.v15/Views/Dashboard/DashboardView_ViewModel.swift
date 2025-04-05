//
//  DashboardView_ViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
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

        var didCancelReserveDialog: Bool = false

        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            accounts = dataSource.fetchAccounts()
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            upcomingNonGroupDebitRecurringTransactions = dataSource.fetchUpcomingRecurringNonGroupDebits()
            upcomingCreditRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .credit)
            upcomingRecurringGroups = dataSource.fetchUpcomingRecurringGroups()
        }

        func refreshScreen() {
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            accounts = dataSource.fetchAccounts()
        }
    }
}
