//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class TransactionTag: ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var name: String = ""
    @Relationship(deleteRule: .noAction) public var accountTransactions: [AccountTransaction]? = nil
    @Relationship(deleteRule: .nullify) public var recurringTransactions: [RecurringTransaction]? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            TransactionTag:
            - id: \(id)
            - name: \(name)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }

    init(
        id: UUID = UUID(),
        name: String = "",
        accountTransactions: [AccountTransaction]? = nil
    ) {
        self.id = id
        self.name = name
        self.accountTransactions = accountTransactions
    }
}
