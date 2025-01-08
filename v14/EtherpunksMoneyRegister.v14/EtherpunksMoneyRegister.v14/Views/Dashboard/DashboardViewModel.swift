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
        var selectedPaydays: [RecurringTransaction] = []
        var selectedUpcomingTransactions: [RecurringTransaction] = []

        var isConfirmReservePaydayModalShowing: Bool = false
        var isConfirmReserveBillsModalShowing: Bool = false
        var didCancel: Bool = false
        var selectedAccount: Account? = nil

        func reservePaydayDismiss(modelContext: ModelContext) {
            if didCancel || selectedAccount == nil {
                didCancel = false
                return
            }

            try? modelContext.transaction {
                selectedPaydays.forEach { item in
                    selectedAccount!.currentBalance += item.amount
                    selectedAccount!.outstandingBalance += item.amount
                    selectedAccount!.outstandingItemCount += 1
                    selectedAccount!.transactionCount += 1

                    modelContext.insert(AccountTransaction(recurringTransaction: item, account: selectedAccount!))

                    try? item.BumpNextDueDate()
                }

            }

            didCancel = false
        }

        func reserveBillsDismiss(modelContext: ModelContext) {
            if didCancel || selectedAccount == nil {
                didCancel = false
                return
            }

            try? modelContext.transaction {
                selectedUpcomingTransactions.forEach { item in
                    selectedAccount!.currentBalance += item.amount
                    selectedAccount!.outstandingBalance += item.amount
                    selectedAccount!.outstandingItemCount += 1
                    selectedAccount!.transactionCount += 1

                    modelContext.insert(AccountTransaction(recurringTransaction: item, account: selectedAccount!))

                    try? item.BumpNextDueDate()
                }

            }

            didCancel = false
            selectedUpcomingTransactions.removeAll()
        }
    }
}
