//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData

@Model
class Account {
    var id: UUID = UUID.init()
    var name: String
    
    var createdOn: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]? = nil
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
