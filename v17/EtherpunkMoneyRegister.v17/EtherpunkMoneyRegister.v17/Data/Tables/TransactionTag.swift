//
//  TransactionFile.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
//

import Foundation
import SwiftData

@Model
final class TransactionTag: Identifiable, Hashable {
    public var name: String = ""
    @Relationship(deleteRule: .noAction) public var accountTransactions: [AccountTransaction]? = []
    @Relationship(deleteRule: .noAction) public var recurringTransactions: [RecurringTransaction]? = []
    public var createdOnUTC: Date = Date()

    init(
        name: String = "",
        accountTransactions: [AccountTransaction] = []
    ) {
        self.name = name
        self.accountTransactions = accountTransactions
    }
}

@MainActor
extension TransactionTag: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            TransactionTag:
            - name: \(name)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }
}
