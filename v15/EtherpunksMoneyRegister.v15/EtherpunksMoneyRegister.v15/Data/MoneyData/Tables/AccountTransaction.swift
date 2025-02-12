//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class AccountTransaction: ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var accountId: UUID? = nil
    public var account: Account? = nil
    public var name: String = ""
    public var transactionType: TransactionType = TransactionType.debit
    public var amount: Decimal = 0
    public var balance: Decimal? = nil
    public var notes: String = ""
    public var confirmationNumber: String = ""
    public var isTaxRelated: Bool = false
    public var fileCount: Int = 0
    @Relationship(deleteRule: .noAction, inverse: \TransactionTag.accountTransactions) public var transactionTags: [TransactionTag]? = nil
    public var recurringTransactionId: UUID? = nil
    @Relationship(deleteRule: .noAction, inverse: \RecurringTransaction.transactions) public var recurringTransaction: RecurringTransaction? = nil
    public var dueDate: Date? = nil
    public var pendingOnUTC: Date? = nil
    public var clearedOnUTC: Date? = nil
    public var balancedOnUTC: Date? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            AccountTransaction:
            - id: \(id)
            - accountId: \(accountId?.uuidString ?? "nil")
            - account: \(account == nil ? "Account is nil" : "Account is loaded")
            - name: \(name)
            - transactionType: \(transactionType)
            - amount: \(amount)
            - balance: \(String(describing: balance))
            - notes: \(notes)
            - confirmationNumber: \(confirmationNumber)
            - isTaxRelated: \(isTaxRelated)
            - fileCount: \(fileCount)
            - transactionTags: \(transactionTags == nil ? "Tags are nil" : "Tags are loaded")
            - recurringTransactionId: \(recurringTransactionId?.uuidString ?? "none")
            - dueDate: \(dueDate?.toDebugDate() ?? "nil")
            - pendingOnUTC: \(pendingOnUTC?.toDebugDate() ?? "nil")
            - clearedOnUTC:\(clearedOnUTC?.toDebugDate() ?? "nil")
            - balancedOnUTC:\(balancedOnUTC?.toDebugDate() ?? "nil")
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            - --- Calculated fields:
            - backgroundColor: \(backgroundColor)
            - transactionStatus: \(transactionStatus)
            """
    }

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
        return self.transactionStatus == .pending
    }

    public var isReserved: Bool {
        return self.transactionStatus == .reserved
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
        self.account = recurringTransaction.defaultAccount ?? nil
        self.name = recurringTransaction.name
        self.transactionType = recurringTransaction.transactionType
        self.amount = recurringTransaction.amount
        self.balance = recurringTransaction.defaultAccount?.currentBalance ?? 0
        self.isTaxRelated = recurringTransaction.isTaxRelated
        self.transactionTags = recurringTransaction.transactionTags
        self.recurringTransaction = recurringTransaction
        self.recurringTransactionId = recurringTransaction.id
        self.dueDate = recurringTransaction.nextDueDate

        VerifySignage()
    }

    init() {
        
    }

    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }
}
