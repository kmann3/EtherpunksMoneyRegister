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
final class AccountTransaction {
    var id: UUID
    var name: String
    var transactionType: TransactionType
    var amount: Decimal
    var balance: Decimal
    var pending: Date?
    var cleared: Date?
    var notes: String
    var confirmationNumber: String
    var recurringTransaction: RecurringTransaction?
    var dueDate: Date?
    var bankTransactionText: String
    var isTaxRelated: Bool
    @Relationship(deleteRule: .cascade, inverse: \AccountTransactionFile.transaction)
    var files: [AccountTransactionFile]?
    @Relationship(deleteRule: .noAction)
    var account: Account?
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]?
    var createdOn: Date

    /// The amount of files associated with the transaction.
    var fileCount: Int {
        self.files?.count ?? 0
    }

    /// The background color indicating the status of the transaction.
    var backgroundColor: Color {
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
    var transactionStatus: TransactionStatus {
        if self.pending == nil && self.cleared == nil {
            return .reserved
        } else if self.pending != nil && self.cleared == nil {
            return .pending
        } else {
            return .cleared
        }
    }

    init(id: UUID = UUID(), account: Account, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal = 0, pending: Date? = nil, cleared: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransaction: RecurringTransaction? = nil, bankTransactionText: String = "", files: [AccountTransactionFile]? = [], tags: [Tag]? = [], isTaxRelated: Bool = false, dueDate: Date? = nil, createdOn: Date = Date()) {
        self.id = id
        self.account = account
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pending = pending
        self.cleared = cleared
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.recurringTransaction = recurringTransaction
        self.dueDate = dueDate
        self.bankTransactionText = bankTransactionText
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.tags = tags
        self.createdOn = createdOn

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
