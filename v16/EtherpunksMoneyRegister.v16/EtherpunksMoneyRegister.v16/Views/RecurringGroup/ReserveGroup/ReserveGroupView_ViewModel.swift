//
//  ReserveGroupView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData
import SwiftUI

extension ReserveGroupView {
    @MainActor
    class ViewModel {
        
        private let dataSource: MoneyDataSource

        var accounts: [Account]
        var reserveGroup: RecurringGroup
        var transactionQueue: [ReserveDraft] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, reserveGroup: RecurringGroup) {
            self.dataSource = dataSource
            self.accounts = dataSource.fetchAccounts()
            self.reserveGroup = reserveGroup

            self.reserveGroup.recurringTransactions!.sorted(by: ({ $0.name < $1.name })).forEach {
                self.transactionQueue.append(ReserveDraft(from: $0))
            }
        }

        func saveTransactions() {
            let ctx = dataSource.modelContext
            for draft in transactionQueue where draft.action == .enable {
                let tran = AccountTransaction(
                    account: draft.account,
                    name: draft.name,
                    transactionType: draft.transactionType,
                    amount: draft.amount,
                    notes: draft.notes,
                    isTaxRelated: draft.isTaxRelated,
                    fileCount: 0,
                    transactionTags: draft.tags,
                    recurringTransaction: draft.recurringTransaction,
                    dueDate: draft.dueDate,
                    pendingOnUTC: nil,
                    clearedOnUTC: nil,
                    balancedOnUTC: nil
                )
                // Update account balances/outstanding like other inserts
                tran.VerifySignage()
                let account = tran.account
                account.currentBalance += tran.amount
                account.outstandingBalance += tran.amount
                account.outstandingItemCount += 1
                account.transactionCount += 1
                tran.balance = account.currentBalance
                ctx.insert(tran)
            }
            do { try ctx.save() } catch { print("Reserve save failed: \(error)") }
        }
    }
}

