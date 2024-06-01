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
    var name: String = ""
    var transactionType: TransactionType = TransactionType.debit
    var amount: Decimal = 0
    var balance: Decimal
    var pending: Date? = nil
    var cleared: Date? = nil
    var notes: String = ""
    var confirmationNumber: String = ""
    var recurringTransaction: RecurringTransaction? = nil
    var bankTransactionText: String = ""
    
    @Relationship(deleteRule: .cascade)
    var files: [AccountTransactionFile]? = nil
    
    @Relationship(deleteRule: .noAction)
    var account: Account
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]? = nil
    
    var createdOn: Date = Date()
    
    var fileCount: Int {
        files == nil ? 0 : files!.count
    }
        
    var backgroundColor: Color {
        if(self.pending == nil && self.cleared == nil) {
            Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        } else if (self.pending != nil && self.cleared == nil) {
            Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        } else {
            Color.clear
        }
    }

    init(name: String, transactionType: TransactionType, amount: Decimal, balance: Decimal, pending: Date? = nil, cleared: Date? = nil, notes: String, confirmationNumber: String, recurringTransaction: RecurringTransaction? = nil, bankTransactionText: String, files: [AccountTransactionFile]? = nil, account: Account, tags: [Tag]? = nil, createdOn: Date) {
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
        
        VerifySignage()
    }
    
    init(name: String, transactionType: TransactionType, amount: Decimal, balance: Decimal, pending: Date? = nil, cleared: Date? = nil, notes: String, confirmationNumber: String, bankTransactionText: String, account: Account, createdOn: Date, tags: [Tag]? = nil) {
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pending = pending
        self.cleared = cleared
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.bankTransactionText = bankTransactionText
        self.account = account
        self.createdOn = createdOn
        self.tags = tags
        
        VerifySignage()
    }
    
    init(name: String, transactionType: TransactionType, amount: Decimal, balance: Decimal, pending: Date?, cleared: Date?, account: Account, tags: [Tag]? = nil) {
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pending = pending
        self.cleared = cleared
        self.account = account
        self.tags = tags
        
        VerifySignage()
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
