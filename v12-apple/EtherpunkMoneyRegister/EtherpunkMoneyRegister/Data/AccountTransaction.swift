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
    /// The name of the transaction.
    var name: String
    
    /// The type of transaction, either debit or credit.
    var transactionType: TransactionType
    
    /// The amount of money involved in the transaction.
    var amount: Decimal
    
    /// The balance after the transaction is applied.
    var balance: Decimal
    
    /// The date when the transaction is pending.
    var pending: Date?
    
    /// The date when the transaction is cleared.
    var cleared: Date?
    
    /// Additional notes about the transaction.
    var notes: String
    
    /// The confirmation number for the transaction, if available. This would be used for things like when you pay a bill.
    var confirmationNumber: String
    
    /// The recurring transaction associated with this transaction, if any. This is so we can keep a history.
    var recurringTransaction: RecurringTransaction?
    
    /// The date the transaction is really due versus what was calculated from the recurring transaction.
    var dueDate: Date?
    
    /// The bank's description of the transaction. This isn't used just yet but in the future it will be used for import purposes.
    /// Example: CA 408 536 6000 ADOBE / Withdrawal @ CA 408 536 6000 ADOBE *PHOTOGPHY PUSADOBE *PHOTOGPH Trace #70108
    // TODO: Implement import from bank
    var bankTransactionText: String
    
    /// A flag for if this transaction should be marked for tax purposes so for next tax season you can pull all tax related items for the year requested into one batch.
    var isTaxRelated: Bool
    
    /// Files associated with the transaction such as a receipt, a contract, or invoice.
    @Relationship(deleteRule: .cascade, inverse: \AccountTransactionFile.transaction)
    var files: [AccountTransactionFile]? = []
    
    /// The account associated with this transaction.
    @Relationship(deleteRule: .noAction)
    var account: Account
    
    /// The tags associated with this transaction.
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]? = []
    
    /// The date the transaction was created on. This is a read-only field and cannot be edited by the user.
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

    init(account: Account, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal = 0, pending: Date? = nil, cleared: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransaction: RecurringTransaction? = nil, bankTransactionText: String = "", files: [AccountTransactionFile]? = [], tags: [Tag]? = [], isTaxRelated: Bool = false, dueDate: Date? = nil, createdOn: Date = Date()) {
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pending = pending
        self.cleared = cleared
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.recurringTransaction = recurringTransaction
        self.bankTransactionText = bankTransactionText
        self.files = files
        self.account = account
        self.tags = tags
        self.createdOn = createdOn
        self.isTaxRelated = isTaxRelated
        self.dueDate = dueDate
        
        self.VerifySignage()
        
//        if(self.balance == 0 && self.amount != 0) {
//            // Probably a simple transaction
//            account.currentBalance += self.amount
//            self.balance = account.currentBalance
//        }
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
