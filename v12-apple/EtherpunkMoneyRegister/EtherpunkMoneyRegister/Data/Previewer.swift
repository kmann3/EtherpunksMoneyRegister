//
//  Previewer.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
struct Previewer {
    let container: ModelContainer
    
    let cuAccount: Account
    let burgerKingTransaction: AccountTransaction
    var cvsTransaction: AccountTransaction
    let billsTag: TransactionTag
    let medicalTag: TransactionTag
    let pharmacyTag: TransactionTag
    let discordRecurringTransaction: RecurringTransaction
    let billGroup: RecurringTransactionGroup
    
    init() throws {
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            TransactionFile.self,
            AppSettings.self,
            TransactionTag.self,
            RecurringTransaction.self,
            RecurringTransactionGroup.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: config)

        print("Database Location: \(container.mainContext.sqliteCommand)")
        print("Generating fake data. This may take a little bit.")

        let specificUUID = UUID(uuidString: "12345678-1234-1234-1234-123456789abc")
        cuAccount = Account(name: "Amegy Bank", startingBalance: 238.99)
        cuAccount.id = specificUUID!

        let boaAccount = Account(name: "Bank of America", startingBalance: 493)
        let axosAccount = Account(name: "Axos", startingBalance: 130494)

        container.mainContext.insert(cuAccount)

        cuAccount.sortIndex = 0
        boaAccount.sortIndex = 255
        axosAccount.sortIndex = 255
        
        billsTag = TransactionTag(name: "bills")
        medicalTag = TransactionTag(name: "medical")
        let ffTag = TransactionTag(name: "fast-food")
        let incomeTag = TransactionTag(name: "income")

        pharmacyTag = TransactionTag(name: "pharmacy")

        var balance: Decimal = 238.99

        for index in (1...3) {
            var tmpIndex = 15+index
            if tmpIndex >= 253 {
                tmpIndex = 253
            }
            let newAccount = Account(name: "Fake Account-\(index)", startingBalance: 0, sortIndex: tmpIndex)
            container.mainContext.insert(newAccount)
        }

        let calendar = Calendar.current

        //let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        var transactionCount: Int = 0
        let amountOfYearsToGenerate: Int = 1
        for index in (1...(amountOfYearsToGenerate*356)).reversed() {

            // 20% chance nothing happens that day
            if Int.random(in: 0..<5) == 0 {
                continue
            }

            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.day! -= index
            components.second = 0
            var date = calendar.date(from: components)!

            components.second! += 1
            date = calendar.date(from: components)!

            // Random number of transaction in a day - between 0 and 4
            for _ in 0...Int.random(in: 0..<5) {
                transactionCount += 1
                var randomAmount: Double = 0
                if(Int.random(in:0..<10) < 9) {
                    // 90% chance it's under $20
                    randomAmount = Double.random(in: 3...20)
                } else {
                    // 10% it's under $100
                    randomAmount = Double.random(in: 20...100)
                }

                randomAmount = (randomAmount*100).rounded() / 100

                var decimalAmount = Decimal(randomAmount)

                if decimalAmount > balance {
                    // do a small deposit to make sure we can cover it

                    var randomDeposit = Double.random(in: 110...150)
                    randomDeposit = (randomDeposit*100).rounded() / 100
                    components.second! += 1
                    date = calendar.date(from: components)!

                    let deposit = Decimal(randomDeposit)
                    balance += deposit
                    transactionCount += 1
                    container.mainContext.insert(AccountTransaction(account: cuAccount, name: "Misc", transactionType: .credit, amount: deposit, balance: balance, cleared: date, balancedOn: date, createdOn: date))
                }

                components.second! += 1
                date = calendar.date(from: components)!

                decimalAmount = -decimalAmount
                balance += decimalAmount
                transactionCount += 1
                container.mainContext.insert(AccountTransaction(account: cuAccount, name: "Fake Transaction \(transactionCount)", transactionType: .debit, amount: decimalAmount, balance: balance, cleared: date, balancedOn: date, createdOn: date))
            }

            if Int.random(in: 0...99) < 4 {
                // Small chance we make a random deposit of less than $100

                var randomAmount = Double.random(in: 20...250)
                randomAmount = (randomAmount*100).rounded() / 100
                let decimalAmount = Decimal(randomAmount)
                components.second! += 1
                date = calendar.date(from: components)!

                balance += decimalAmount
                transactionCount += 1
                container.mainContext.insert(AccountTransaction(account: cuAccount, name: "Cash depo", transactionType: .credit, amount: decimalAmount, balance: balance, cleared: date, balancedOn: date, createdOn: date))

            }

            if Int.random(in: 0...99) < 2 {
                // let's make an income deposit

                let deposit: Decimal = 2013.73
                components.second! += 1
                date = calendar.date(from: components)!

                balance += deposit
                transactionCount += 1
                container.mainContext.insert(AccountTransaction(account: cuAccount, name: "Paycheck", transactionType: .credit, amount: deposit, balance: balance, cleared: date, balancedOn: date, createdOn: date))
            }
        }

        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        transactionCount += 1
        burgerKingTransaction = AccountTransaction(account: cuAccount, name: "Burger King", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), tags: [ffTag], balancedOn: Date())

        transactionAmount = -8.79
        balance = balance + transactionAmount
        transactionCount += 1
        let wendysTransaction = AccountTransaction(account: cuAccount, name: "Wendys", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), tags: [ffTag])

        transactionAmount = -88.34
        balance = balance + transactionAmount
        transactionCount += 1
        cvsTransaction = AccountTransaction(account: cuAccount, name: "CVS", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), tags: [medicalTag, pharmacyTag], balancedOn: Date())

        transactionAmount = -10.81
        balance = balance + transactionAmount
        transactionCount += 1
        let discordTransaction = AccountTransaction(account: cuAccount, name: "Discord", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: nil, tags: [billsTag])

        transactionAmount = -36.81
        balance = balance + transactionAmount
        transactionCount += 1
        let fitnessTransaction = AccountTransaction(account: cuAccount, name: "Fitness", transactionType: .debit, amount: transactionAmount, balance: balance, pending: Date(), cleared: nil, tags: [billsTag])

        transactionAmount = 2318.79
        balance = balance + transactionAmount
        transactionCount += 1
        let paydayTransaction = AccountTransaction(account: cuAccount, name: "Payday", transactionType: .credit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), tags: [incomeTag])
        
        let cuOutstandingAmount: Decimal = discordTransaction.amount + fitnessTransaction.amount
        
        cuAccount.outstandingBalance = cuOutstandingAmount
        cuAccount.outstandingItemCount = 2
        cuAccount.currentBalance = balance
        cuAccount.transactionCount = transactionCount
        boaAccount.currentBalance = 55.43
        axosAccount.currentBalance = axosAccount.startingBalance
        
        discordRecurringTransaction = RecurringTransaction(name: "Discord", transactionType: .debit, amount: -10.81, notes: "", nextDueDate: nil, tags: [billsTag], transactions: [discordTransaction], frequency: .monthly, createdOn: Date())
        
        let fitnessRecurringTransaction = RecurringTransaction(name: "Fitness", transactionType: .debit, amount: -33.49, notes: "Contract ends Mar 13 2025", nextDueDate: Date(), tags: [billsTag], transactions: [fitnessTransaction], frequency: .monthly, createdOn: Date())
        
        billGroup = RecurringTransactionGroup(name: "Bills", recurringTransactions: [discordRecurringTransaction, fitnessRecurringTransaction])
        
        cvsTransaction.isTaxRelated = true
        
        discordRecurringTransaction.nextDueDate = getNextDueDate(day: 16)
        
        let monkeyURL: URL? = downloadImageFromURL()
        if monkeyURL == nil {
            print("An error?")
        }
        
        let fakeAttachment = TransactionFile(name: "Logo", filename: "monkey.jpg", notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.", createdOn: Date(), url: monkeyURL!, isTaxRelated: true, transaction: cvsTransaction)

        container.mainContext.insert(burgerKingTransaction)
        container.mainContext.insert(wendysTransaction)
        container.mainContext.insert(cvsTransaction)
        container.mainContext.insert(fakeAttachment)
        container.mainContext.insert(discordTransaction)
        container.mainContext.insert(fitnessTransaction)
        container.mainContext.insert(paydayTransaction)
        container.mainContext.insert(boaAccount)
        container.mainContext.insert(axosAccount)
        container.mainContext.insert(billGroup)

        print("Done generating fake data.")
        print("Fake transactions created: \(transactionCount)")
    }
    
    private func getNextDueDate(day: Int) -> Date {
        let calendar = Calendar.current
        
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        var monthsToAdd = 0
        
        if currentComponents.day! > 16 {
            monthsToAdd = 1
        }
        
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.month! += monthsToAdd
        components.day = 16
        
        let date = calendar.date(from: components)
        return date!
    }
    
    func downloadImageFromURL(completion: @escaping (URL?) -> Void) {
        let monkeyUrlString = "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"
        
        guard let url = URL(string: monkeyUrlString) else {
            print("Invalid URL: \(monkeyUrlString)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try data.write(to: destinationURL)
                print("Destination: \(destinationURL)")
                completion(destinationURL)
            } catch {
                print("Error saving image data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    private func downloadImageFromURL() -> URL? {
        let monkeyUrl = "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"
        
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

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
