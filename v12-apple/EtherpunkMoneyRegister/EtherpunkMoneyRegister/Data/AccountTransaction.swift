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
class AccountTransaction {
    var uuid: UUID = UUID.init()
    var name: String = ""
    var transactionType: TransactionType = TransactionType.debit
    var amount: Decimal = 0
    var balance: Decimal
    var pending: Date? = nil
    var cleared: Date? = nil
    var notes: String = ""
    var confirmationNumber: String = ""
    // tags
    // link to recurring transaction if needed
    var bankTransactionText: String = ""
    // Transaction Type Enum
    // files        
    @Relationship(deleteRule: .noAction)
    var account: Account
    var createdOn: Date = Date()
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]? = nil

    init(uuid: UUID, name: String, transactionType: TransactionType, amount: Decimal, balance: Decimal, pending: Date? = nil, cleared: Date? = nil, notes: String, confirmationNumber: String, bankTransactionText: String, account: Account, createdOn: Date, tags: [Tag]? = nil) {
        self.uuid = uuid
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
