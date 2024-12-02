//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class AccountTransaction : ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable  {
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
    public var filesCount: Int = 0
    @Relationship(deleteRule: .noAction, inverse: \TransactionTag.accountTransactions) public var transactionTags: [TransactionTag]? = nil
    public var recurringTransactionId: UUID? = nil
    public var dueDate: Date? = nil
    public var pendingOnUTC: Date? = nil
    public var clearedOnUTC: Date? = nil
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
            - filesCount: \(filesCount)
            - transactionTags: \(transactionTags == nil ? "Tags are nil" : "Tags are loaded")
            - recurringTransactionId: \(recurringTransactionId?.uuidString ?? "none")
            - dueDate: \(dueDate?.description ?? "nil")
            - pendingOnUTC: \(pendingOnUTC?.description ?? "nil")
            - clearedOnUTC:\(clearedOnUTC?.description ?? "nil")
            - createdOnUTC: \(createdOnUTC)
            - --- Calculated fields:
            - backgroundColor: \(backgroundColor)
            - transactionStatus: \(transactionStatus)
            """
    }

    /// The background color indicating the status of the transaction.
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .cleared:
            Color.clear
        case .pending:
            Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        case .reserved:
            Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        }
    }

    /// The inferred status of the transaction.
    public var transactionStatus: TransactionStatus {
        if self.pendingOnUTC == nil && self.clearedOnUTC == nil {
            return .reserved
        } else if self.pendingOnUTC != nil && self.clearedOnUTC == nil {
            return .pending
        } else {
            return .cleared
        }
    }

    init(
        accountId: UUID? = nil,
        name: String = "",
        transactionType: TransactionType = .debit,
        amount: Decimal = 0,
        balance: Decimal? = nil,
        notes: String = "",
        confirmationNumber: String = "",
        isTaxRelated: Bool = false,
        filesCount: Int = 0,
        transactionTags: [TransactionTag]? = nil,
        recurringTransactionId: UUID? = nil,
        dueDate: Date? = nil,
        pendingOnUTC: Date? = nil,
        clearedOnUTC: Date? = nil
    ) {
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.isTaxRelated = isTaxRelated
        self.filesCount = filesCount
        self.transactionTags = transactionTags
        self.recurringTransactionId = recurringTransactionId
        self.dueDate = dueDate
        self.pendingOnUTC = pendingOnUTC
        self.clearedOnUTC = clearedOnUTC

        self.VerifySignage()
    }

    init(
        name: String,
        accountId: UUID,
        transactionType: TransactionType,
        amount: Decimal,
        balance: Decimal,
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

    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }
}
