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
        var selectedTag: TransactionTag? = nil

        init(_ dataSource: MoneyDataSource = MoneyDataSource.shared, selectedTag: TransactionTag? = nil) {
            self.dataSource = dataSource
            self.tags = self.dataSource.fetchAllTags()

            if selectedTag != nil {
                self.selectedTag = selectedTag
            }
        }
    }
}
