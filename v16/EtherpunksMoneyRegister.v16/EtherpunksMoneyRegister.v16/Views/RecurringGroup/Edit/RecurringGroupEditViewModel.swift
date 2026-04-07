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
        
        var group: RecurringGroup
        var isNew: Bool = false
        
        @Published var draft: RecurringGroupDraft

        init(group: RecurringGroup, isNew: Bool, dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.group = group
            self.isNew = isNew

            self.draft = RecurringGroupDraft(group: group)
        }

        func save() {
            self.group.name = draft.name
            // TODO: Implement rest of the data

            if self.isNew {
                self.dataSource.insertRecurringGroup(self.group)
            } else {
                self.dataSource.updateRecurringGroup(self.group)
            }
        }
    }
}
