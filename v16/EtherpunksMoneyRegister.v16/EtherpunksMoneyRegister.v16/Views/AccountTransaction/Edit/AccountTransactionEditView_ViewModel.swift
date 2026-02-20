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
        
        @Published var draft: Draft

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction) {
            self.dataSource = dataSource

            self.tran = tran
            self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
            self.draft = Draft(tran: tran)
            
            if self.draft.fileCount > 0 {
                // Load the files
                self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
            }
        }

        func addNewDocument() {
            // TODO: Implement addNewDocument for AccountTransactionEditView
        }

        func addNewPhoto() {
            // TODO: Implement addNewPhoto for AccountTransactionEditView
        }
        
        func save() {
            guard let amount = draft.decimalAmount else { return }
            let origAmount = tran.amount
            let origAccount = tran.account
            let tran = self.tran
            tran.name = draft.name
            tran.account = draft.account
            tran.transactionType = draft.transactionType
            tran.amount = amount
            tran.isTaxRelated = draft.isTaxRelated
            tran.confirmationNumber = draft.confirmationNumber
            tran.notes = draft.notes
            tran.pendingOnUTC = draft.hasPending ? draft.pendingOn : nil
            tran.clearedOnUTC = draft.hasCleared ? draft.clearedOn : nil
            tran.dueDate = draft.hasDueDate ? draft.dueDate : nil
            tran.balancedOnUTC = draft.hasBalanced ? draft.balancedOn : nil
            tran.transactionTags = draft.tags
            tran.VerifySignage()
            
            // TODO: Files and filesDidChange
            self.dataSource.updateTransactionFile(tran: tran, origAccount: origAccount, origAmount: origAmount, files: self.files, filesDidChange: self.filesDidChange)
        }
    }
}
