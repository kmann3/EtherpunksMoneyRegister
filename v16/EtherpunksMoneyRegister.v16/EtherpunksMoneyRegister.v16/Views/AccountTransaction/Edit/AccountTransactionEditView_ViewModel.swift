//
//  AccountTransactionEditView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionEditView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource

        var tran: AccountTransaction
        var files: [TransactionFile] = []
        var draft: Draft

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction) {
            self.dataSource = dataSource

            self.tran = tran
            self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
            self.draft = Draft(tran: tran)
        }

        func addNewDocument() {
            // TODO: Implement addNewDocument for AccountTransactionEditView
        }

        func addNewPhoto() {
            // TODO: Implement addNewPhoto for AccountTransactionEditView
        }
        
        func save() {
            guard let amount = draft.decimalAmount else { return }
            let tran = self.tran
            tran.name = draft.name
            tran.account = draft.account // TODO: Send a bool value when saving to adjust accounts accordingly for the loss/gain
            tran.transactionType = draft.transactionType
            tran.amount = amount // TODO: Send a bool value when saving to adjust account accordingly
            tran.isTaxRelated = draft.isTaxRelated
            tran.confirmationNumber = draft.confirmationNumber
            tran.notes = draft.notes
            tran.pendingOnUTC = draft.hasPending ? draft.pendingOn : nil
            tran.clearedOnUTC = draft.hasCleared ? draft.clearedOn : nil
            tran.dueDate = draft.hasDueDate ? draft.dueDate : nil
            tran.transactionTags = draft.tags
            tran.VerifySignage()
            // TODO: self.dataSource.updateTransaction()
        }

        struct Draft {
            var name: String
            var account: Account
            var transactionType: TransactionType
            var amountString: String
            var isTaxRelated: Bool
            var confirmationNumber: String
            var notes: String
            var pendingOn: Date?
            var clearedOn: Date?
            var dueDate: Date?
            var tags: [TransactionTag]
            var hasPending: Bool
            var hasCleared: Bool
            var hasDueDate: Bool

            init(tran: AccountTransaction) {
                name = tran.name
                account = tran.account
                transactionType = tran.transactionType
                amountString = tran.amount.description
                isTaxRelated = tran.isTaxRelated
                confirmationNumber = tran.confirmationNumber
                notes = tran.notes
                pendingOn = tran.pendingOnUTC
                clearedOn = tran.clearedOnUTC
                dueDate = tran.dueDate
                tags = tran.transactionTags
                hasPending = tran.pendingOnUTC != nil
                hasCleared = tran.clearedOnUTC != nil
                hasDueDate = tran.dueDate != nil
            }

            var isValid: Bool {
                !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && decimalAmount != nil
            }

            var decimalAmount: Decimal? {
                Decimal(string: amountString.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}
