//
//  Tag_Editor_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/1/25.
//

import Foundation
import SwiftUI
import SwiftData

extension TagEditor {
    
    @Observable
    class ViewModel {
        var tag: TransactionTag
        var associatedTransactions: [AccountTransaction]?
        var tagName: String = ""

        var isNewTransaction: Bool = true

        init(tagToLoad: TransactionTag) {
            tag = tagToLoad
            tagName = tag.name

            if tag.name != "" {
                isNewTransaction = false
            }
        }

        public func saveTag(modelContext: ModelContext) {
            if hasChanges() {
                tag.name = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
                do {
                    if isNewTransaction {
                        modelContext.insert(tag)
                    }

                    try modelContext.save()
                } catch {
                    debugPrint(error)
                }
            }
        }

        private func hasChanges() -> Bool {
            if tagName.trimmingCharacters(in: .whitespacesAndNewlines) != tag.name {
                return true
            }

            return false
        }
//        func saveTag() {
//            if(hasChanges() == false) {
//                // do a popup? Saying no changes made?
//            } else {
//                //            self.tag.name = _tagName.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
//                //
//                //            do {
//                //                if isNewTransaction {
//                //                    modelContext.insert(self.tag)
//                //                }
//                //
//                //                try modelContext.save()
//                //                presentationMode.wrappedValue.dismiss()
//                //            } catch {
//                //                debugPrint(error)
//                //            }
//            }
//        }
//
//        func hasChanges() -> Bool {
//            var hasChanges = false
//
//            //        if(self.tag.name != _tagName.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
//            //            hasChanges = true
//            //        }
//
//            return hasChanges
//        }
    }
}
