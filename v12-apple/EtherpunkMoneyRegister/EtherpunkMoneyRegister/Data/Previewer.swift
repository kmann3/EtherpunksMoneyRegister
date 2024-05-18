//
//  Previewer.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: AccountTransaction.self, configurations: config)
        
        let cuAccount: Account = Account(name: "MCT Credit Union", startingBalance: 238.99)
        
        let ffTag: Tag = Tag(name: "fast-food")
        let billsTag: Tag = Tag(name: "bills")

        var balance: Decimal = 238.99
        
        var transactionAmount: Decimal = -12.39
        balance = balance+transactionAmount
        let burgerKingTransaction: AccountTransaction = AccountTransaction(name: "Burger King", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), account: cuAccount, tags: [ffTag])
        
        transactionAmount = -10.81
        balance = balance + transactionAmount
        
        let discordTransaction: AccountTransaction = AccountTransaction(name: "Discord", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: nil, account: cuAccount, tags: [billsTag])
        
        transactionAmount = -36.81
        balance = balance + transactionAmount
        
        let fitnessTransaction: AccountTransaction = AccountTransaction(name: "Fitness", transactionType: .debit, amount: transactionAmount, balance: balance, pending: Date(), cleared: nil, account: cuAccount, tags: [billsTag])
        
        container.mainContext.insert(cuAccount)
        container.mainContext.insert(burgerKingTransaction)
        container.mainContext.insert(discordTransaction)
        container.mainContext.insert(fitnessTransaction)

    }
}
