//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation

final class TransactionFile : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var filename: String = ""
    public var notes: String = ""
    public var data: [Data]? = nil
    public var isTaxRelated: Bool = false
    public var transactionId: UUID? = nil

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation

    public var createdOnUTC: Date  = Date()

    public var debugDescription: String {
        return """
            TransactionFile:
            - id: \(id)
            - name: \(name)
            - fileName: \(filename)
            - notes: \(notes)
            - data size in bytes: \(data?.count ?? 0)
            - isTaxRelated: \(isTaxRelated)
            - createdOnUTC: \(createdOnUTC)
            """
    }

    init(
        id: UUID,
        name: String,
        filename: String,
        notes: String,
        data: [Data]? = nil,
        isTaxRelated: Bool,
        transactionId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.data = data
        self.isTaxRelated = isTaxRelated
        self.transactionId = transactionId
    }

    init(
        name: String,
        filename: String,
        data: [Data],
        isTaxRelated: Bool,
        transactionId: UUID?
    ) {
        self.name = name
        self.filename = filename
        self.data = data
        self.isTaxRelated = isTaxRelated
        self.transactionId = transactionId
    }
}
