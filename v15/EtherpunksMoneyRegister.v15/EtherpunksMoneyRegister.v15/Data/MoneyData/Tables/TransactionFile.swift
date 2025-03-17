//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation
import SwiftData

@Model
final class TransactionFile: ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable {
    @Attribute(.unique) public var id: String = UUID().uuidString
    public var name: String = ""
    public var filename: String = ""
    public var notes: String = ""
    public var data: Data? = nil
    public var isTaxRelated: Bool = false
    public var transactionId: String? = nil
    @Relationship(deleteRule: .noAction) public var transaction: AccountTransaction?

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation

    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            TransactionFile:
            - id: \(id)
            - name: \(name)
            - fileName: \(filename)
            - notes: \(notes)
            - data size in bytes: \(data?.count ?? 0)
            - isTaxRelated: \(isTaxRelated)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            - transaction: \(String(describing: transaction))
            """
    }

    init(
        name: String,
        filename: String,
        notes: String,
        data: Data,
        isTaxRelated: Bool,
        accountTransaction: AccountTransaction
    ) {
        self.name = name
        self.filename = filename
        self.notes = notes
        self.data = data
        self.isTaxRelated = isTaxRelated
        self.transaction = accountTransaction
        self.transactionId = accountTransaction.id
    }
}
