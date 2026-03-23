//
//  RecurringTransaction_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/19/26.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringGroupListView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource
        
        var recurringGroupList: [RecurringGroup] = []
        
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.recurringGroupList = self.dataSource.fetchAllRecurringGroups()
        }
    }
}
