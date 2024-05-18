//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
class Tag {
    var id: UUID = UUID.init()
    var name: String
    
    @Relationship(deleteRule: .noAction, inverse: \AccountTransaction.tags)
    var transactions: [AccountTransaction]? = nil
    
    var createdOn: Date = Date()
    
    // recurring transactions
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
