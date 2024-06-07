//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class AccountTransactionFile {
    var name: String = ""
    var filename: String = ""
    var notes: String = ""
    var createdOn: Date = Date()
    var url: URL
    var isTaxRelated: Bool = false
    
    @Relationship(deleteRule: .noAction)
    var transaction: AccountTransaction? = nil
    
    init(name: String, filename: String, notes: String, createdOn: Date, url: URL, isTaxRelated: Bool, transaction: AccountTransaction) {
        self.name = name
        self.filename = filename
        self.notes = notes
        self.createdOn = createdOn
        self.url = url
        self.transaction = transaction
    }
    
    init(filename: String, url: URL, transaction: AccountTransaction) {
        self.name = filename
        self.filename = filename
        self.url = url
        self.transaction = transaction
    }
}
