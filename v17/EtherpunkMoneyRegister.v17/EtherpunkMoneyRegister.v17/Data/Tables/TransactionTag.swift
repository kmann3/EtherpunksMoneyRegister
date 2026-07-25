//
//  TransactionTag.swift
//  EtherpunkMoneyRegister.v17
//
//  Represents a tag for categorizing financial transactions, supporting relationships
//  to both account and recurring transactions. Used throughout the app for organization,
//  filtering, and analytics.
//
//  Created by Kenny Mann on 7/14/26.
//  Last updated: 7/25/26
//

import Foundation
import SwiftData
import UUIDV7

/// A tag model for grouping transactions within the app.
///
/// `TransactionTag` instances are used to apply labels to both single and recurring transactions,
/// supporting categorization and custom filtering mechanisms throughout the UI.
///
/// - Important: Tags do not enforce deletion rules on associated transactions.
/// - SeeAlso: `AccountTransaction`, `RecurringTransaction`
@Model
final class TransactionTag: Identifiable, Hashable {
    /// Unique identifier for this tag, using UUIDv7.
    public var id: UUIDV7 = UUIDV7()
    
    /// User-defined label for the tag.
    public var name: String = ""
    
    /// All account transactions associated with this tag.
    ///
    /// - Note: Relationships are not deleted automatically when the tag is deleted.
    @Relationship(deleteRule: .noAction) public var accountTransactions: [AccountTransaction]? = []
    
    /// All recurring transactions associated with this tag.
    ///
    /// - Note: Relationships are not deleted automatically when the tag is deleted.
    @Relationship(deleteRule: .noAction) public var recurringTransactions: [RecurringTransaction]? = []
    
    /// The UTC creation timestamp for this tag.
    public var createdOnUTC: Date = Date()

    /// Initialize a `TransactionTag` with a name and associated transactions.
    /// - Parameters:
    ///   - name: A descriptive label for the tag.
    ///   - accountTransactions: Initial set of transactions associated with the tag.
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
    /// Custom debug output for quick inspection of tag details.
    /// Shows the tag's name and creation date.
    public var debugDescription: String {
        return """
            TransactionTag:
            - name: \(name)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }
}
