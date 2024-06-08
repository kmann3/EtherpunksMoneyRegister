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
final class AccountTransaction {
    var name: String
    var transactionType: TransactionType
    var amount: Decimal
    var balance: Decimal
    var pending: Date?
    var cleared: Date?
    var notes: String
    var confirmationNumber: String
    var recurringTransaction: RecurringTransaction?
    var bankTransactionText: String
    var isTaxRelated: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \AccountTransactionFile.transaction)
    var files: [AccountTransactionFile]?
    
    @Relationship(deleteRule: .noAction)
    var account: Account
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]?
    
    var createdOn: Date
    
    var fileCount: Int {
        files?.count ?? 0
    }
        
    var backgroundColor: Color {
        switch transactionStatus {
        case .cleared:
            Color.clear
        case .pending:
            Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        case .reserved:
            Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        }
    }
    
    var transactionStatus: TransactionStatus {
        if(self.pending == nil && self.cleared == nil) {
            return .reserved
        } else if (self.pending != nil && self.cleared == nil) {
            return .pending
        } else {
            return .cleared
        }
    }

    init(name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal = 0, pending: Date? = nil, cleared: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransaction: RecurringTransaction? = nil, bankTransactionText: String = "", files: [AccountTransactionFile]? = nil, account: Account, tags: [Tag]? = nil, isTaxRelated: Bool = false, createdOn: Date = Date()) {
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
        
        VerifySignage()
        
        if(self.balance == 0 && self.amount != 0) {
            // Probably a simple transaction
            account.currentBalance += self.amount
            self.balance = account.currentBalance
        }
    }
    
    func VerifySignage() {
        switch(self.transactionType) {
            case .credit:
                self.amount = abs(self.amount)
                break;
            
            case .debit:
            self.amount = -abs(self.amount)
                break;
        }
    }
}
