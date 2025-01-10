//
//  DashboardViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/8/25.
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

        var pathStore: PathStore

        var accounts: [Account]
        var pendingTransactions: [AccountTransaction]
        var reservedTransactions: [AccountTransaction]
        
        var upcomingCreditRecurringTransactions: [RecurringTransaction]
        var upcomingDebitRecurringTransactions: [RecurringTransaction]

        var selectedCreditRecurringTransactions: [RecurringTransaction] = []
        var selectedDebitRecurringTransactions: [RecurringTransaction] = []

        var isConfirmReserveCreditDialogShowing: Bool = false
        var isConfirmReserveDebitDialogShowing: Bool = false

        var selectedAccountFromReserveDialog: Account? = nil
        var didCancelReserveDialog: Bool = false

        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            accounts = dataSource.fetchAccounts()
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            upcomingDebitRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .debit)
            upcomingCreditRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .credit)
        }

        func reserveReserveDialogDismiss(transactionType: TransactionType) {
            if didCancelReserveDialog || selectedAccountFromReserveDialog == nil {
                didCancelReserveDialog = false
                return
            }

            switch transactionType {
            case .credit:
                dataSource.reserveTransactions(selectedCreditRecurringTransactions, account: selectedAccountFromReserveDialog!)
                selectedCreditRecurringTransactions = []
            case .debit:
                dataSource.reserveTransactions(selectedDebitRecurringTransactions, account: selectedAccountFromReserveDialog!)
                selectedDebitRecurringTransactions = []
            }

            // refresh screen's data, since it is all reserved and not pending - we just need to do this.
            reservedTransactions = dataSource.fetchAllReservedTransactions()

            didCancelReserveDialog = false

        }

    }
}
