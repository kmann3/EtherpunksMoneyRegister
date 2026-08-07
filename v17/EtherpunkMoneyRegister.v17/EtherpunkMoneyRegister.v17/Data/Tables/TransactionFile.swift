//
//  TransactionFile.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
//

import Foundation
import SwiftData
import UUIDV7

@Model
final class TransactionFile: Identifiable, Hashable {
    public var id: UUIDV7 = UUIDV7()
    public var name: String = ""
    public var filename: String = ""
    public var notes: String = ""
    public var data: Data? = nil
    public var isTaxRelated: Bool = false
    public var transactionId: String? = nil
    @Relationship(deleteRule: .noAction) public var transaction: AccountTransaction? = nil

    // TODO: Files might also have different tags such as: receipt, documentation, confirmation; Consider enums? Or just actual tags?

    public var createdOnUTC: Date = Date()

    init(
        id: UUIDV7 = UUIDV7(),
        name: String,
        filename: String,
        notes: String,
        data: Data,
        isTaxRelated: Bool,
        accountTransaction: AccountTransaction
    ) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.data = data
        self.isTaxRelated = isTaxRelated
        self.transaction = accountTransaction
    }

    func getFormattedFileSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        if self.data == nil {
            return "nil"
        } else {
            return formatter.string(fromByteCount: Int64(self.data!.count))
        }
    }
}

@MainActor
extension TransactionFile: CustomDebugStringConvertible {
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
}

