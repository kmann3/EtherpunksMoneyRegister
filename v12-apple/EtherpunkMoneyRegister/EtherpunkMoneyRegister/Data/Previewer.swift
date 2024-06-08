//
//  Previewer.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    
    let container: ModelContainer
    
    let cuAccount: Account
    let burgerKingTransaction: AccountTransaction
    var cvsTransaction: AccountTransaction
    let billsTag: Tag
    let medicalTag: Tag
    let pharmacyTag: Tag
    let discordRecurringTransaction: RecurringTransaction
    let billGroup: RecurringTransactionGroup
    
    init() throws {
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            AccountTransactionFile.self,
            AppSettings.self,
            Tag.self,
            RecurringTransaction.self,
            RecurringTransactionGroup.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: config)
        
        cuAccount = Account(name: "Amegy Bank", startingBalance: 238.99)
        let boaAccount: Account = Account(name: "Bank of America", startingBalance: 492)
        let axosAccount: Account = Account(name: "Axos", startingBalance: 130494)
        
        cuAccount.sortIndex = 0
        boaAccount.sortIndex = 255
        axosAccount.sortIndex = 255
        
        billsTag = Tag(name: "bills")
        medicalTag = Tag(name: "medical")
        let ffTag: Tag = Tag(name: "fast-food")
        let incomeTag: Tag = Tag(name: "income")
        
        pharmacyTag = Tag(name: "pharmacy")
        
        var balance: Decimal = 238.99
        
        var transactionAmount: Decimal = -12.39
        balance = balance+transactionAmount
        burgerKingTransaction = AccountTransaction(name: "Burger King", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), account: cuAccount, tags: [ffTag])

        transactionAmount = -8.79
        balance = balance+transactionAmount
        let wendysTransaction: AccountTransaction = AccountTransaction(name: "Wendys", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), account: cuAccount, tags: [ffTag])
        
        transactionAmount = -88.34
        balance = balance+transactionAmount
        cvsTransaction = AccountTransaction(name: "CVS", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), account: cuAccount, tags: [medicalTag, pharmacyTag])
                
        transactionAmount = -10.81
        balance = balance + transactionAmount
        
        let discordTransaction: AccountTransaction = AccountTransaction(name: "Discord", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: nil, account: cuAccount, tags: [billsTag])
        
        transactionAmount = -36.81
        balance = balance + transactionAmount
        
        let fitnessTransaction: AccountTransaction = AccountTransaction(name: "Fitness", transactionType: .debit, amount: transactionAmount, balance: balance, pending: Date(), cleared: nil, account: cuAccount, tags: [billsTag])
        
        transactionAmount = 2318.79
        balance = balance + transactionAmount
        
        let paydayTransaction: AccountTransaction = AccountTransaction(name: "Payday", transactionType: .credit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), account: cuAccount, tags: [incomeTag])
        
        let cuOutstandingAmount: Decimal = discordTransaction.amount + fitnessTransaction.amount
        
        cuAccount.outstandingBalance = cuOutstandingAmount
        cuAccount.outstandingItemCount = 2
        cuAccount.currentBalance = balance
        boaAccount.currentBalance = 55.43
        axosAccount.currentBalance = axosAccount.startingBalance
                
        discordRecurringTransaction = RecurringTransaction(name: "Discord", transactionType: .debit, amount: -10.81, notes: "", nextDueDate: nil, tags: [billsTag], transactions: [discordTransaction], frequency: .monthly, createdOn: Date())
        
        billGroup = RecurringTransactionGroup(name: "Bills", recurringTransactions: [discordRecurringTransaction])
        
        discordRecurringTransaction.nextDueDate = getNextDueDate(day: 16)
        let monkeyURL: URL? = downloadImageFromURL()
        if(monkeyURL == nil) {
            print("An error?")
        }
        let fakeAttachment: AccountTransactionFile = AccountTransactionFile(name: "Logo", filename: "monkey.jpg", notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.", createdOn: Date(), url: monkeyURL!, isTaxRelated: true, transaction: cvsTransaction)
        
        container.mainContext.insert(cuAccount)
        container.mainContext.insert(burgerKingTransaction)
        container.mainContext.insert(wendysTransaction)
        container.mainContext.insert(cvsTransaction)
        container.mainContext.insert(fakeAttachment)
        container.mainContext.insert(discordTransaction)
        container.mainContext.insert(fitnessTransaction)
        container.mainContext.insert(paydayTransaction)
        container.mainContext.insert(boaAccount)
        container.mainContext.insert(axosAccount)
        //container.mainContext.insert(discordRecurringTransaction)
        
        container.mainContext.insert(fakeAttachment)
        
       container.mainContext.insert(billGroup)

    }
    
    private func getNextDueDate(day: Int) -> Date {
        let calendar = Calendar.current

        let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        var monthsToAdd: Int = 0

        if(currentComponents.day! > 16) {
            monthsToAdd = 1
        }


        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.month! += monthsToAdd
        components.day = 16

        let date = calendar.date(from: components)
        return date!
    }
    
    private func downloadImageFromURL() -> URL? {
        let monkeyUrl: String = "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"
        
        guard let url = URL(string: monkeyUrl) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            try data.write(to: destinationURL)
            return destinationURL
        } catch {
            print("Error downloading file: \(error)")
            return nil
        }
    }
}
