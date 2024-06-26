//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class TransactionFile {
    var id: UUID = UUID()
    var name: String = ""
    var filename: String = ""
    var notes: String = ""
    var createdOn: Date = Date()
    var url: URL? = nil
    var data: Data? = nil
    var isTaxRelated: Bool = false

    @Relationship(deleteRule: .noAction)
    var transaction: AccountTransaction?

    init(id: UUID = UUID(), name: String = "", filename: String = "", notes: String = "", createdOn: Date = Date(), url: URL? = nil, data: Data? = nil, isTaxRelated: Bool = false, transaction: AccountTransaction? = nil) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.createdOn = createdOn
        self.url = url
        self.data = data
        self.transaction = transaction
        self.isTaxRelated = isTaxRelated
    }

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation
}
