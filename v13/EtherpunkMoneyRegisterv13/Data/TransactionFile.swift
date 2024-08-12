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
    var fileType: FileType? = nil

    @Relationship(deleteRule: .noAction)
    var transaction: AccountTransaction?

    var transactionId: UUID? = nil

    init(id: UUID = UUID(), name: String = "", filename: String = "", notes: String = "", createdOn: Date = Date(), url: URL? = nil, data: Data? = nil, fileType: FileType? = nil ,isTaxRelated: Bool = false, transaction: AccountTransaction? = nil, transactionId: UUID? = nil) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.createdOn = createdOn
        self.url = url
        self.data = data
        self.transaction = transaction
        self.isTaxRelated = isTaxRelated
        self.fileType = fileType
        if(transactionId == nil) {
            self.transactionId = transaction!.id
        } else {
            self.transactionId = transactionId
        }
    }

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation
}
