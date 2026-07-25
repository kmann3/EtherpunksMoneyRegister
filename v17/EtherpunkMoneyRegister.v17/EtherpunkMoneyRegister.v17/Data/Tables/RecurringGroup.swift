//
//  RecurringGroup.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
//

import Foundation
import SwiftData
import UUIDV7

@Model
final class RecurringGroup: Identifiable, Hashable {
    public var id: UUIDV7 = UUIDV7()
    public var name: String = ""
    @Relationship(deleteRule: .nullify) public var recurringTransactions: [RecurringTransaction]? = []
    public var createdOnUTC: Date = Date()


    init(
        name: String = "",
        recurringTransactions: [RecurringTransaction] = []
    ) {
        self.name = name
        self.recurringTransactions = recurringTransactions
    }

    init(name: String) {
        self.name = name
    }
}

@MainActor
extension RecurringGroup: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            RecurringGroup:
            - name: \(name)
            - recurringTransactions Count: \(recurringTransactions?.count ?? -1)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }
}
