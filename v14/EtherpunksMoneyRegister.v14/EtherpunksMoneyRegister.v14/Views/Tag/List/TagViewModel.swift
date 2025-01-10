//
//  TagViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var pathStore: PathStore

        var tags: [TransactionTag]
        var tagToDelete: TransactionTag? = nil
        var isDeleteWarningPresented: Bool = false

        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            self.tags = dataSource.fetchAllTags()
        }

        func deleteTag() {
            if tagToDelete == nil {
                print("No tag to delete")
                return
            }

            dataSource.deleteTag(tagToDelete!)

            self.tags = dataSource.fetchAllTags()
        }
    }
}
