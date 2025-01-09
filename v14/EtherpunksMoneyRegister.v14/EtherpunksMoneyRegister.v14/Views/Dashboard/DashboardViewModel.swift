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

        @MainActor
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            accounts = dataSource.fetchAccounts()
            reservedTransactions = dataSource.fetchAllReservedTransactions()
            pendingTransactions = dataSource.fetchAllPendingTransactions()
            upcomingDebitRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .debit)
            upcomingCreditRecurringTransactions = dataSource.fetchUpcomingRecurringTransactions(transactionType: .credit)
        }

//        func reservePaydayDismiss(modelContext: ModelContext) {
//            if didCancel || selectedAccount == nil {
//                didCancel = false
//                return
//            }
//
//            try? modelContext.transaction {
//                selectedPaydays.forEach { item in
//                    selectedAccount!.currentBalance += item.amount
//                    selectedAccount!.outstandingBalance += item.amount
//                    selectedAccount!.outstandingItemCount += 1
//                    selectedAccount!.transactionCount += 1
//
//                    modelContext.insert(AccountTransaction(recurringTransaction: item, account: selectedAccount!))
//
//                    try? item.BumpNextDueDate()
//                }
//                
//                do {
//                    try modelContext.save()
//                } catch {
//                    modelContext.rollback()
//                    debugPrint("An error saving has occured")
//                }
//            }
//
//            didCancel = false
//            selectedPaydays.removeAll()
//        }
//
//        func reserveBillsDismiss(modelContext: ModelContext) {
//            if didCancel || selectedAccount == nil {
//                didCancel = false
//                return
//            }
//
//            try? modelContext.transaction {
//                selectedUpcomingTransactions.forEach { item in
//                    selectedAccount!.currentBalance += item.amount
//                    selectedAccount!.outstandingBalance += item.amount
//                    selectedAccount!.outstandingItemCount += 1
//                    selectedAccount!.transactionCount += 1
//
//                    modelContext.insert(AccountTransaction(recurringTransaction: item, account: selectedAccount!))
//
//                    try? item.BumpNextDueDate()
//                }
//
//                do {
//                    try modelContext.save()
//                } catch {
//                    modelContext.rollback()
//                    debugPrint("An error saving has occured")
//                }
//            }
//
//            didCancel = false
//            selectedUpcomingTransactions.removeAll()
//        }
    }
}
