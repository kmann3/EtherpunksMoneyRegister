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

        var isConfirmReserveDebitGroupDialogShowing: Bool = false
        var selectedDebitGroup: RecurringGroup = RecurringGroup()
        var returnTransactions: [AccountTransaction] = []

        var isConfirmReserveDebitTransactionDialogShowing: Bool = false
        var selectedDebitRecurringTransaction: RecurringTransaction = RecurringTransaction()

        var isConfirmDepositCreditDialogShowing: Bool = false
        var returnTransaction: AccountTransaction = AccountTransaction()
        var selectedCreditRecurringTransaction: RecurringTransaction = RecurringTransaction()

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

        func reserveDepositCreditDialogDismiss() {
            if didCancelReserveDialog {
                didCancelReserveDialog = false
                return
            }

            dataSource.ReserveCreditDeposit(
                recurringTransaction: selectedCreditRecurringTransaction,
                newTransaction: returnTransaction
            )

            refreshScreen()
        }

        func reserveDepositDebitGroupDialogDismiss() {
            if didCancelReserveDialog {
                didCancelReserveDialog = false
                return
            }

            dataSource.ReserveDebitGroup(
                group: selectedDebitGroup,
                newTransactions: returnTransactions)

            refreshScreen()
        }

        func reserveDepositDebitTransactionDialogDismiss() {
            if didCancelReserveDialog {
                didCancelReserveDialog = false
                return
            }

            dataSource.ReserveDebitTransaction(
                recurringTransaction: selectedDebitRecurringTransaction,
                newTransaction: returnTransaction
            )

            refreshScreen()
        }
    }
}
