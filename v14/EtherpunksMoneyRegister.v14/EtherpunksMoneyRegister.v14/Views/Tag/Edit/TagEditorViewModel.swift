//
//  TagEditorViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagEditorView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var pathStore: PathStore

        var tag: TransactionTag
        var tagName: String = ""
        var isNewTag: Bool = false
        var isShowingDeleteAlert: Bool = false

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tag: TransactionTag) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
            self.tag = tag

            if self.tag.name == "" {
                isNewTag = true
            }

            self.tagName = tag.name
        }

        func deleteTag() {
            self.dataSource.deleteTag(tag)
        }

        func saveTag() {
            self.tag.name = tagName
            if isNewTag {
                self.dataSource.createTag(tag)
            } else {
                self.dataSource.updateTag(tag)
            }
        }
    }
}
