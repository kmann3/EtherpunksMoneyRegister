//
//  RecurringGroupListViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringGroupListView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var recurringGroups: [RecurringGroup] = []
        var selectedGroup: RecurringGroup? = nil

        init(_ dataSource: MoneyDataSource = MoneyDataSource.shared, selectedGroup: RecurringGroup? = nil) {
            self.dataSource = dataSource
            self.selectedGroup = selectedGroup

            self.recurringGroups = self.dataSource.fetchAllRecurringGroups()
        }
    }
}
