// 
//  RecurringGroupDraft.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import Foundation
import SwiftUI

struct RecurringGroupDraft {
    var name: String
    // TBI: RecurringGroup rest of variables here
    var recurringTransactions: [RecurringTransaction]? = nil
    
    init(group: RecurringGroup) {
        name = group.name
        recurringTransactions = group.recurringTransactions
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
