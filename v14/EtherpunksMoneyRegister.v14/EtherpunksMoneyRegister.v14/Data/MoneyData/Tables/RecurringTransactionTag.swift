//
//  RecurringTransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/12/24.
//

import Foundation
import SwiftData

@Model
final class RecurringTransactionTag : ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable  {
    static func == (lhs: RecurringTransactionTag, rhs: RecurringTransactionTag) -> Bool {
        let areEqual = lhs.id == rhs.id && lhs.name == rhs.name && lhs.createdOnUTC == rhs.createdOnUTC
        return areEqual
    }

    @Attribute(.unique) public var id: UUID = UUID()
    public var name: String
    public var recurringTransactions: [RecurringTransaction]? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            RecurringTransactionTag:
            - id: \(id)
            - name: \(name)
            - createdOnUTC: \(createdOnUTC)
            """
    }

    init(
        id: UUID = UUID(),
        name: String,
        recurringTransactions: [RecurringTransaction]? = nil
    ) {
        self.id = id
        self.name = name
        self.recurringTransactions = recurringTransactions
    }

    init(name: String) {
        self.name = name
    }
}
