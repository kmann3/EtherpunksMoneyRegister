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
    var transactionType: TransactionType = TransactionType.Debit
    var amount: Decimal = 0
    var balance: Decimal
    var pendingUTC: Date? = nil
    var clearedUTC: Date? = nil
    var notes: String = ""
    var confirmationNumber: String = ""
    // tags
    // link to recurring transaction if needed
    var bankTransactionText: String = ""
    // Transaction Type Enum
    // files        
    @Relationship(deleteRule: .noAction)
    var account: Account
    var createdOnUTC: Date = Date()
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]? = nil


    init(uuid: UUID, name: String, transactionType: TransactionType, amount: Decimal, balance: Decimal, pendingUTC: Date? = nil, clearedUTC: Date? = nil, account: Account, notes: String, confirmationNumber: String, bankTransactionText: String) {
        self.uuid = uuid
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pendingUTC = pendingUTC
        self.clearedUTC = clearedUTC
        self.account = account
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.bankTransactionText = bankTransactionText
    }
    
    init(name: String, amount: Decimal, balance: Decimal, transactionType: TransactionType, account: Account) {
        self.name = name
        self.amount = amount
        self.transactionType = transactionType
        self.balance = balance
        self.account = account
    }
}
