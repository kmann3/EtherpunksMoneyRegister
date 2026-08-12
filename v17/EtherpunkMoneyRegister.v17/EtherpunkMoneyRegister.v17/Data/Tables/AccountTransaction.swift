//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
//

import Foundation
import SwiftData
import SwiftUI
import UUIDV7

/**
 AccountTransaction is a model representing a financial transaction linked to a specific account.
 This model is the core and most useful information. Treat it like you would a wet napkin - carefully.

 The model tracks basic financial information, such as amounts and transaction type,
 as well as lifecycle timestamps like pending, cleared, and balanced dates. Additional metadata includes notes, tags, attached files,
 and links to recurring transactions. Computed helpers provide convenience access to semantic transaction type, status, and UI colors.
*/
/// A persisted financial transaction belonging to an account.
///
/// AccountTransaction represents a single debit or credit entry.
/// It stores amounts, timestamps for lifecycle events (pending, cleared, balanced),
/// and metadata such as tags and files. Computed helpers expose derived values like
/// `transactionType` (via a raw stored value), `transactionStatus`, and a suggested
/// `backgroundColor` for UI.
/// - SeeAlso: `Account`, `RecurringTransaction`, `TransactionFile`, `TransactionTag`
@Model
final class AccountTransaction: Identifiable, Hashable {
    /// Unique identifier for this transaction.
    public var id: UUIDV7 = UUIDV7()

    /// Identifier of the owning account for this transaction.
    public var accountId: UUIDV7

    /// A short, human-readable description of the transaction (e.g. payee or memo).
    public var name: String = ""
    /// The semantic type of the transaction (credit or debit).
    ///
    /// Backed by `transactionTypeRaw` for persistence.
    /// 
    public var transactionType: TransactionType {
        get { TransactionType(rawValue: transactionTypeRaw) ?? .debit }
        set { transactionTypeRaw = newValue.rawValue }
    }

    /// Raw persisted value for `transactionType`.
    private var transactionTypeRaw: TransactionType.RawValue = TransactionType.debit.rawValue

    /// The signed amount of the transaction. Credits are positive; debits are negative.
    /// The sign is normalized by `VerifySignage()`.
    public var amount: Decimal = 0

    /// Optional running balance at the time of this transaction, if recorded.
    public var balance: Decimal? = nil

    /// Free-form notes about the transaction.
    public var notes: String = ""

    /// External confirmation or reference number associated with the transaction.
    public var confirmationNumber: String = ""

    /// Indicates whether this transaction is relevant for tax reporting.
    public var isTaxRelated: Bool = false

    /// Number of files attached to this transaction.
    public var fileCount: Int = 0

    /// Attached files (e.g., receipts) associated with this transaction.
    public var transactionFiles: [TransactionFile] = []

    /// Tags used to categorize or label this transaction.
    public var transactionTags: [TransactionTag] = []

    /// If set, links this instance to its originating recurring transaction.
    public var recurringTransactionId: UUIDV7? = nil

    /// Optional due date for scheduled or recurring transactions.
    public var dueDate: Date? = nil

    /// Timestamp (UTC) when the transaction became pending.
    public var pendingOnUTC: Date? = nil

    /// Timestamp (UTC) when the transaction cleared.
    public var clearedOnUTC: Date? = nil

    /// Timestamp (UTC) when the transaction was balanced/reconciled.
    public var balancedOnUTC: Date? = nil
    
    /// A history of all the changes to this object
    public var changeLogs: String = "\(Date().toSummaryDateyyyyMMddHHmmSS()) - Initial incarnation"
    
    /// Timestamp (UTC) when the transaction record was created.
    public var createdOnUTC: Date = Date()

    /// A suggested background color indicating the status of the transaction.
    ///
    /// Note: Consider adapting colors via user preferences (e.g., color blindness support).
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .balanced:
            Color.clear
        case .cleared:
            // green
            Color(
                .sRGB, red: 0 / 255, green: 150 / 255, blue: 25 / 255,
                opacity: 0.5)
        case .empty: // This should never happen. Let's make it a purple so it stands out
            Color(
                .sRGB, red: 255 / 255, green: 0 / 255, blue: 255 / 255,
                opacity: 0.5)
        case .recurring:
            // blue
            Color(
                .sRGB, red: 0 / 255, green: 115 / 255, blue: 210 / 255,
                opacity: 0.5)
        case .pending:
            // yellow
            Color(
                .sRGB, red: 255 / 255, green: 150 / 255, blue: 25 / 255,
                opacity: 0.5)
        case .reserved:
            // red
            Color(
                .sRGB, red: 255 / 255, green: 25 / 255, blue: 25 / 255,
                opacity: 0.5)
        }
    }

    /// An inferred status derived from date fields and recurrence.
    ///
    /// - reserved: No pending or cleared dates present.
    /// - pending: Pending date set, but not cleared.
    /// - recurring: Linked to a recurring transaction.
    /// - balanced: Balanced date set.
    /// - cleared: Cleared date set.
    /// - empty: Fallback state when no other conditions apply.
    public var transactionStatus: TransactionStatus {
        if self.pendingOnUTC == nil && self.clearedOnUTC == nil {
            return .reserved
        } else if self.pendingOnUTC != nil && self.clearedOnUTC == nil {
            return .pending
        } else {
            if self.recurringTransactionId != nil {
                return .recurring
            } else if self.balancedOnUTC != nil {
                return .balanced
            } else if self.clearedOnUTC != nil {
                return .cleared
            }
            return .empty
        }
    }

    /// Convenience flag indicating whether the transaction is currently pending.
    public var isPending: Bool {
        if case .pending = self.transactionStatus { return true }
        return false
    }

    /// Convenience flag indicating whether the transaction is currently reserved.
    public var isReserved: Bool {
        if case .reserved = self.transactionStatus { return true }
        return false
    }

    /// Initializes a new transaction with comprehensive fields.
    /// - Parameters:
    ///   - id: Unique identifier, default is a new UUIDV7.
    ///   - accountId: Identifier of the owning account.
    ///   - name: Human-readable description.
    ///   - transactionType: Credit or debit; persisted via `transactionTypeRaw`.
    ///   - amount: Signed amount; normalized by `VerifySignage()`.
    ///   - balance: Optional running balance at this point in time.
    ///   - notes: Free-form notes.
    ///   - confirmationNumber: External confirmation/reference.
    ///   - isTaxRelated: Whether the transaction is tax relevant.
    ///   - fileCount: Number of attached files.
    ///   - transactionTags: Categorization tags.
    ///   - recurringTransactionId: Link to a recurring transaction if applicable.
    ///   - dueDate: Optional due date.
    ///   - pendingOnUTC: When the transaction became pending (UTC).
    ///   - clearedOnUTC: When the transaction cleared (UTC).
    ///   - balancedOnUTC: When the transaction was balanced (UTC).
    ///
    /// Calls `VerifySignage()` to ensure amount sign matches `transactionType`.
    init(
        id: UUIDV7 = UUIDV7(),
        accountId: UUIDV7,
        name: String = "",
        transactionType: TransactionType = .debit,
        amount: Decimal = 0,
        balance: Decimal? = nil,
        notes: String = "",
        confirmationNumber: String = "",
        isTaxRelated: Bool = false,
        fileCount: Int = 0,
        transactionTags: [TransactionTag] = [],
        recurringTransactionId: UUIDV7? = nil,
        dueDate: Date? = nil,
        pendingOnUTC: Date? = nil,
        clearedOnUTC: Date? = nil,
        balancedOnUTC: Date? = nil
    ) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.isTaxRelated = isTaxRelated
        self.fileCount = fileCount
        self.transactionTags = transactionTags
        self.recurringTransactionId = recurringTransactionId
        self.dueDate = dueDate
        self.pendingOnUTC = pendingOnUTC
        self.clearedOnUTC = clearedOnUTC
        self.balancedOnUTC = balancedOnUTC

        self.VerifySignage()
    }

    /// Initializes a transaction with core fields.
    /// - Parameters:
    ///   - accountId: Identifier of the owning account.
    ///   - name: Human-readable description.
    ///   - transactionType: Credit or debit.
    ///   - amount: Signed amount; normalized by `VerifySignage()`.
    ///   - balance: Optional running balance.
    ///   - pendingOnUTC: Pending timestamp (UTC).
    ///   - clearedOnUTC: Cleared timestamp (UTC).
    init(
        accountId: UUIDV7,
        name: String,
        transactionType: TransactionType,
        amount: Decimal,
        balance: Decimal?,
        pendingOnUTC: Date? = nil,
        clearedOnUTC: Date? = nil
    ) {
        self.name = name
        self.accountId = accountId
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pendingOnUTC = pendingOnUTC
        self.clearedOnUTC = clearedOnUTC

        self.VerifySignage()
    }

    /// Creates an instance from a `RecurringTransaction` template.
    /// - Parameters:
    ///   - recurringTransaction: The source recurring template.
    ///   - currentBalance: The current balance to capture for this instance.
    init(recurringTransaction: RecurringTransaction, currentBalance: Decimal) {
        self.accountId = recurringTransaction.defaultAccountId!
        self.name = recurringTransaction.name
        self.transactionType = recurringTransaction.transactionType
        self.amount = recurringTransaction.amount
        self.balance = currentBalance
        self.isTaxRelated = recurringTransaction.isTaxRelated
        self.transactionTags = recurringTransaction.transactionTags
        self.recurringTransactionId = recurringTransactionId
        self.dueDate = recurringTransaction.nextDueDate

        VerifySignage()
    }

    /// Ensures `amount` has the correct sign for the `transactionType`.
    /// Credits are positive; debits are negative.
    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }

    
    /// Produces a shallow copy of the transaction for testing or seeding.
    ///
    /// Files are not copied; `fileCount` is reset to zero.
    /// - Returns: A new `AccountTransaction` with similar values.
    func Clone() -> AccountTransaction {
        return AccountTransaction(
            accountId: self.accountId,
            name: self.name,
            transactionType: self.transactionType,
            amount: self.amount,
            balance: self.balance,
            notes: self.notes,
            confirmationNumber: self.confirmationNumber,
            isTaxRelated: self.isTaxRelated,
            fileCount: 0,
            transactionTags: self.transactionTags,
            recurringTransactionId: self.recurringTransactionId,
            dueDate: self.dueDate,
            pendingOnUTC: self.pendingOnUTC,
            clearedOnUTC: self.clearedOnUTC,
            balancedOnUTC: self.balancedOnUTC
        )
    }
    
    /// Fetches transactions for the specified account.
    /// - Note: Not yet implemented.
    func fetchAccountTransactions(accountId: UUIDV7) -> [AccountTransaction] {
        fatalError("TBI")
    }
}

@MainActor
extension AccountTransaction: CustomDebugStringConvertible {
    /// A multi-line debug description summarizing the transaction and derived fields.
    public var debugDescription: String {
        return """
            AccountTransaction:
            - id: \(id)
            - accountId: \(accountId)
            - name: \(name)
            - transactionType: \(transactionType)
            - amount: \(amount)
            - balance: \(String(describing: balance))
            - notes: \(notes)
            - confirmationNumber: \(confirmationNumber)
            - isTaxRelated: \(isTaxRelated)
            - fileCount: \(fileCount)
            - transactionTags: (Count: \(transactionTags.count))
            - recurringTransaction: \(recurringTransactionId?.uuidString ?? "nil")
            - dueDate: \(dueDate?.toDebugDate() ?? "nil")
            - pendingOnUTC: \(pendingOnUTC?.toDebugDate() ?? "nil")
            - clearedOnUTC: \(clearedOnUTC?.toDebugDate() ?? "nil")
            - balancedOnUTC: \(balancedOnUTC?.toDebugDate() ?? "nil")
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            - --- Calculated fields:
            - backgroundColor: \(backgroundColor)
            - transactionStatus: \(transactionStatus)
            """
    }
}

