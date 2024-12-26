//
//  Link_RecurringTransaction_RecurringTransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/19/24.
//

import Foundation

final class Link_RecurringTransaction_RecurringTransactionTag : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var recurringTransactionId: UUID? = nil
    public var recurringTransactionTagId: UUID? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
            return """
            RecurringTransactionTag:
            - recurringTransactionId: \(recurringTransactionId)
            - recurringTransactionTagId: \(recurringTransactionTagId)
            - createdOnUTC: \(createdOnUTC)
            """
    }

    init(recurringTransactionId: UUID, recurringTransactionTagId: UUID) {
        self.recurringTransactionId = recurringTransactionId
        self.recurringTransactionTagId = recurringTransactionTagId
    }
}
