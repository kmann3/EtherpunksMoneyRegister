//
//  AccountTransactionEditView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

extension AccountTransactionEditView {
    @MainActor
    class ViewModel : ObservableObject {
        private let dataSource: MoneyDataSource

        var tran: AccountTransaction
        var files: [TransactionFile] = []
        var filesDidChange: Bool = false
        var isNewTransaction: Bool = false
        
        @Published var draft: AccountTransactionDraft

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction, isNewTransaction: Bool) {
            self.dataSource = dataSource

            self.tran = tran
            self.isNewTransaction = isNewTransaction
            self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
            self.draft = AccountTransactionDraft(tran: tran)
            
            if self.draft.fileCount > 0 {
                // Load the files
                self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
            }
        }

        func addNewFile() {
            // TODO: Implement addNewDocument for AccountTransactionEditView
        }
        
        func save() {
            let origAmount = tran.amount
            let origAccount = tran.account
            let tran = self.tran
            tran.name = draft.name
            tran.account = draft.account
            tran.accountId = draft.account.id
            tran.transactionType = draft.transactionType
            tran.amount = draft.amount
            tran.isTaxRelated = draft.isTaxRelated
            tran.confirmationNumber = draft.confirmationNumber
            tran.notes = draft.notes
            tran.pendingOnUTC = draft.hasPending ? draft.pendingOn : nil
            tran.clearedOnUTC = draft.hasCleared ? draft.clearedOn : nil
            tran.dueDate = draft.hasDueDate ? draft.dueDate : nil
            tran.balancedOnUTC = draft.hasBalanced ? draft.balancedOn : nil
            tran.transactionTags = draft.tags
            tran.VerifySignage()
            
            // TODO: Files and filesDidChange ; I'm not even sure if there's a clean way to do this other than "just let it handle itself and just save it. Seems like updating a fat file could be painful?
            
            if self.isNewTransaction {
                self.dataSource.insertAccountTransaction(transaction: tran)
            } else {
                self.dataSource.updateAccountTransaction(tran: tran, origAccount: origAccount, origAmount: origAmount, files: self.files, filesDidChange: self.filesDidChange)
            }
        }
    }
}
