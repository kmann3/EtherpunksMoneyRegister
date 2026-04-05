// 
//  RecurringGroupEditViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

extension RecurringGroupEditView {
    @MainActor
    class ViewModel : ObservableObject {
        private let dataSource: MoneyDataSource
        
        var item: RecurringGroup
        var isNew: Bool = false
        
        @Published var draft: RecurringGroupDraft

        init(item: RecurringGroup, isNew: Bool, dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.item = item
            self.isNew = isNew

            self.draft = RecurringGroupDraft(item: item)
        }

        func save() {
            // TBI: Implement save RecurringGroup
            if self.isNew {
                //self.dataSource.insertAccountTransaction(transaction: tran)
            } else {
                //self.dataSource.updateAccountTransaction(tran: tran, origAccount: origAccount)
            }
        }
    }
}
