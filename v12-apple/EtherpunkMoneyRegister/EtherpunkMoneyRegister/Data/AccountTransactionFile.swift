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
final class AccountTransactionFile {
    var name: String = ""
    var filename: String = ""
    var notes: String = ""
    var createdOn: Date
    var url: URL?
    var isTaxRelated: Bool

    @Relationship(deleteRule: .noAction)
    var transaction: AccountTransaction?

    init(name: String = "", filename: String = "", notes: String = "", createdOn: Date = Date(), url: URL? = nil, isTaxRelated: Bool = false, transaction: AccountTransaction) {
        self.name = name
        self.filename = filename
        self.notes = notes
        self.createdOn = createdOn
        self.url = url
        self.transaction = transaction
        self.isTaxRelated = isTaxRelated
    }
}
