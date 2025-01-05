//
//  Link_Transaction_TransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/19/24.
//

import Foundation
import SwiftData

@Model
final class Link_Transaction_TransactionTag: ObservableObject,
    CustomDebugStringConvertible, Identifiable, Hashable
{
    public var transactionId: UUID? = nil
    public var transactionTagId: UUID? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            RecurringTransactionTag:
            - transactionId: \(String(describing: transactionId))
            - transactionTagId: \(String(describing: transactionTagId))
            - createdOnUTC: \(createdOnUTC)
            """
    }

    init(transactionId: UUID, transactionTagId: UUID) {
        self.transactionId = transactionId
        self.transactionTagId = transactionTagId
    }
}
