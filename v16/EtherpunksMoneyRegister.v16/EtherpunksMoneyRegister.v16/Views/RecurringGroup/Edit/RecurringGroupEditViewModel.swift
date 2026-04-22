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
        
        var recurringGroup: RecurringGroup
        var isNew: Bool = false
        
        @Published var draft: RecurringGroupDraft

        init(recurringGroup: RecurringGroup, isNew: Bool, dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.recurringGroup = recurringGroup
            self.isNew = isNew

            self.draft = RecurringGroupDraft(group: recurringGroup)
        }

        func save() {
            self.recurringGroup.name = draft.name
            // TODO: Implement rest of the data

            if self.isNew {
                self.dataSource.insertRecurringGroup(self.recurringGroup)
            } else {
                self.dataSource.updateRecurringGroup(self.recurringGroup)
            }
        }
    }
}
