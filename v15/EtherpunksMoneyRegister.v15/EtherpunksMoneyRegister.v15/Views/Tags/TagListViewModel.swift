//
//  TagListViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/11/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagListView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var tags: [TransactionTag] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.tags = self.dataSource.fetchAllTags()
        }
    }
}
