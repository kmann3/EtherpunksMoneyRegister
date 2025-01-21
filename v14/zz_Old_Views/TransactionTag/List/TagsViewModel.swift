//
//  TagsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/1/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagsView {

    @Observable
    class ViewModel {
        var isDeleteWarningPresented: Bool = false
        var tagToDelete: TransactionTag? = nil

        func deleteTag() {
            isDeleteWarningPresented = false
            debugPrint("Deleting tag: \(tagToDelete!.name)")
        }
    }
}
