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
    @Attribute(.unique) public var id: String = UUID().uuidString
    public var name: String = ""
    @Relationship(deleteRule: .noAction) public var accountTransactions: [AccountTransaction]? = nil
    @Relationship(deleteRule: .noAction) public var recurringTransactions: [RecurringTransaction]? = nil // The delete rule should be nullify by during debugging, it's a pain to clear all the values here without giving errors. Blame SwiftData for being poorly made.
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
        self.id = id.uuidString
        self.name = name
        self.accountTransactions = accountTransactions
    }
}
