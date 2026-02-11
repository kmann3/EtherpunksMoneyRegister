//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData
import SwiftUI
import UUIDV7

@Model
final class AccountTransaction: Identifiable, Hashable {
    @Attribute(.unique) public var id: String = UUIDV7().uuidString
    public var account: Account
    public var accountId: String? = nil
    public var name: String = ""
    public var transactionType: TransactionType {
        get { TransactionType(rawValue: transactionTypeRaw) ?? .debit }
        set { transactionTypeRaw = newValue.rawValue }
    }
    private var transactionTypeRaw: TransactionType.RawValue = TransactionType.debit.rawValue
    public var amount: Decimal = 0
    public var balance: Decimal? = nil
    public var notes: String = ""
    public var confirmationNumber: String = ""
    public var isTaxRelated: Bool = false
    public var fileCount: Int = 0
    @Relationship(deleteRule: .noAction, inverse: \TransactionTag.accountTransactions) public var transactionTags: [TransactionTag]? = []
    public var recurringTransactionId: String? = nil
    @Relationship(deleteRule: .noAction, inverse: \RecurringTransaction.transactions) public var recurringTransaction: RecurringTransaction? = nil
    public var dueDate: Date? = nil
    public var pendingOnUTC: Date? = nil
    public var clearedOnUTC: Date? = nil
    public var balancedOnUTC: Date? = nil
    public var createdOnUTC: Date = Date()

    // TODO: Allow for user based changes for color-blindness.
    /// The background color indicating the status of the transaction.
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .balanced:
            Color(
                .sRGB, red: 0 / 255, green: 150 / 255, blue: 25 / 255,
                opacity: 0.5)
        case .cleared:
            Color.clear
        case .empty:
            Color.clear
        case .recurring:
            // blue
            Color(
                .sRGB, red: 0 / 255, green: 80 / 255, blue: 150 / 255,
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

    /// The inferred status of the transaction.
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

    public var isPending: Bool {
        if case .pending = self.transactionStatus { return true }
        return false
    }

    public var isReserved: Bool {
        if case .reserved = self.transactionStatus { return true }
        return false
    }

    init(
        account: Account,
        name: String = "",
        transactionType: TransactionType = .debit,
        amount: Decimal = 0,
        balance: Decimal? = nil,
        notes: String = "",
        confirmationNumber: String = "",
        isTaxRelated: Bool = false,
        fileCount: Int = 0,
        transactionTags: [TransactionTag]? = nil,
        recurringTransaction: RecurringTransaction? = nil,
        dueDate: Date? = nil,
        pendingOnUTC: Date? = nil,
        clearedOnUTC: Date? = nil,
        balancedOnUTC: Date? = nil
    ) {
        self.account = account
        self.accountId = account.id
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.isTaxRelated = isTaxRelated
        self.fileCount = fileCount
        self.transactionTags = transactionTags
        self.recurringTransaction = recurringTransaction
        self.recurringTransactionId = recurringTransaction?.id ?? nil
        self.dueDate = dueDate
        self.pendingOnUTC = pendingOnUTC
        self.clearedOnUTC = clearedOnUTC
        self.balancedOnUTC = balancedOnUTC

        self.VerifySignage()
    }

    init(
        account: Account,
        name: String,
        transactionType: TransactionType,
        amount: Decimal,
        balance: Decimal,
        pendingOnUTC: Date? = nil,
        clearedOnUTC: Date? = nil
    ) {
        self.name = name
        self.account = account
        self.accountId = account.id
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pendingOnUTC = pendingOnUTC
        self.clearedOnUTC = clearedOnUTC

        self.VerifySignage()
    }

    init(recurringTransaction: RecurringTransaction) {
        self.account = recurringTransaction.defaultAccount
        self.accountId = recurringTransaction.defaultAccount.id
        self.name = recurringTransaction.name
        self.transactionType = recurringTransaction.transactionType
        self.amount = recurringTransaction.amount
        self.balance = recurringTransaction.defaultAccount.currentBalance
        self.isTaxRelated = recurringTransaction.isTaxRelated
        self.transactionTags = recurringTransaction.transactionTags
        self.recurringTransaction = recurringTransaction
        self.recurringTransactionId = recurringTransaction.id
        self.dueDate = recurringTransaction.nextDueDate

        VerifySignage()
    }

    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }

    
    /// Clones the current account transaction
    /// This is primarily used for creating fake data and should not use used in production
    /// - Returns: Returns a new account transaction similar to this one. EXCEPT no files are copied. It will have ZERO files.
    func Clone() -> AccountTransaction {
        return AccountTransaction(
            account: self.account,
            name: self.name,
            transactionType: self.transactionType,
            amount: self.amount,
            balance: self.balance,
            notes: self.notes,
            confirmationNumber: self.confirmationNumber,
            isTaxRelated: self.isTaxRelated,
            fileCount: 0,
            transactionTags: self.transactionTags,
            recurringTransaction: self.recurringTransaction,
            dueDate: self.dueDate,
            pendingOnUTC: self.pendingOnUTC,
            clearedOnUTC: self.clearedOnUTC,
            balancedOnUTC: self.balancedOnUTC
        )
    }
}

@MainActor
extension AccountTransaction: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            AccountTransaction:
            - id: \(id)
            - accountId: \(String(describing: accountId))
            - account: \(account.name)
            - name: \(name)
            - transactionType: \(transactionType)
            - amount: \(amount)
            - balance: \(String(describing: balance))
            - notes: \(notes)
            - confirmationNumber: \(confirmationNumber)
            - isTaxRelated: \(isTaxRelated)
            - fileCount: \(fileCount)
            - transactionTags: \(transactionTags == nil ? "Tags are nil" : "Tags are loaded")
            - recurringTransactionId: \(String(describing: recurringTransactionId))
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

