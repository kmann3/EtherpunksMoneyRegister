//
//  SettingsView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/1/24.
//

import CoreData
import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()

    var body: some View {
        List {
            Section(header: Text("Notifications")) {
                Button("Alerts for upcoming transactions") {}
                Button("Alerts for empty transactions") {}
                Button("Alerts for unbalanced accounts") {}
            }
            Section(header: Text("Data")) {
                Button("Export Data") {}
                Button("Generate Fake Data") { generateData() }
                Button("Archive Data") {}
                Spacer()
                Button(action: {purgeData()}) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Delete All Data")
                        Image(systemName: "exclamationmark.triangle")
                    }
                }
                .foregroundColor(.red)
            }
            Section(header: Text("Defaults")) {
                Button("Default Account") {}
                Button("Default Pending/Cleared") {}
            }
        }
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
    
    func generateData() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var balance: Decimal = 238.99
        let amegyAccount = Account(name: "Amegy Bank", startingBalance: balance)
        modelContext.insert(amegyAccount)

        try? modelContext.save()

        let billsTag = TransactionTag(name: "bills")
        let ffTag = TransactionTag(name: "fast-food")
        let incomeTag = TransactionTag(name: "income")
        let medicalTag = TransactionTag(name: "medical")
        let pharmacyTag = TransactionTag(name: "pharmacy")

        modelContext.insert(billsTag)
        modelContext.insert(ffTag)
        modelContext.insert(incomeTag)
        modelContext.insert(medicalTag)
        modelContext.insert(pharmacyTag)
        modelContext.insert(TransactionTag(name: "copay"))
        modelContext.insert(TransactionTag(name: "fuel"))
        modelContext.insert(TransactionTag(name: "groceries"))

        try? modelContext.save()

        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        let burgerKingTransaction = AccountTransaction(account: amegyAccount, name: "Burger King", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date(), isTaxRelated: false)
        modelContext.insert(burgerKingTransaction)
        burgerKingTransaction.transactionTags = [ffTag]

        transactionAmount = -8.79
        balance = balance + transactionAmount
        let wendysTransaction = AccountTransaction(account: amegyAccount, name: "Wendys", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date())
        modelContext.insert(wendysTransaction)
        wendysTransaction.transactionTags = [ffTag]

        transactionAmount = -88.34
        balance = balance + transactionAmount
        let cvsTransaction = AccountTransaction(account: amegyAccount, name: "CVS", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date())
        modelContext.insert(cvsTransaction)
        cvsTransaction.transactionTags = [medicalTag, pharmacyTag]

        downloadImageFromURL { monkeyURL in
            if let monkeyURL = monkeyURL {
                cvsTransaction.files?.append(TransactionFile(name: "LogoOld", filename: "monkey1.jpg", notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.", createdOn: dateFormatter.date(from: "2016-04-14T10:44:00-0500")!, url: monkeyURL, isTaxRelated: true, transaction: cvsTransaction))
                cvsTransaction.files?.append(TransactionFile(name: "LogoNew", filename: "monkey1.jpg", notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.", url: monkeyURL, isTaxRelated: true, transaction: cvsTransaction))
            } else {
                print("Error: Could not download monkey from Etherpunk")
            }
        }
        
        transactionAmount = -10.81
        balance = balance + transactionAmount
        
        let discordTransaction = AccountTransaction(account: amegyAccount, name: "Discord", transactionType: .debit, amount: transactionAmount, balance: balance, pending: nil, cleared: nil)
        modelContext.insert(discordTransaction)
        discordTransaction.transactionTags = [billsTag]

        transactionAmount = -36.81
        balance = balance + transactionAmount
        
        let fitnessTransaction = AccountTransaction(account: amegyAccount, name: "Fitness", transactionType: .debit, amount: transactionAmount, balance: balance, pending: Date(), cleared: nil)
        modelContext.insert(fitnessTransaction)
        fitnessTransaction.transactionTags = [billsTag]

        transactionAmount = 2318.79
        balance = balance + transactionAmount
        
        let paydayTransaction = AccountTransaction(account: amegyAccount, name: "Payday", transactionType: .credit, amount: transactionAmount, balance: balance, pending: nil, cleared: Date())
        modelContext.insert(paydayTransaction)
        paydayTransaction.transactionTags = [incomeTag]

        let cuOutstandingAmount: Decimal = discordTransaction.amount + fitnessTransaction.amount
        
        amegyAccount.outstandingBalance = cuOutstandingAmount
        amegyAccount.outstandingItemCount = 2
        amegyAccount.currentBalance = balance
        
        let discordRecurringTransaction = RecurringTransaction(name: "Discord", transactionType: .debit, amount: -10.81, notes: "", nextDueDate: nil, transactionTags: [billsTag], transactions: [discordTransaction], frequency: .monthly, createdOn: Date())
        discordRecurringTransaction.nextDueDate = getNextDueDate(day: 16)
        
        modelContext.insert(discordRecurringTransaction)
        
        let billGroup = RecurringTransactionGroup(name: "Bills", recurringTransactions: [discordRecurringTransaction])
        
        modelContext.insert(billGroup)
        
        try? modelContext.save()
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
    
    func purgeData() {
        do {
            try modelContext.delete(model: Account.self)
            try modelContext.delete(model: AccountTransaction.self)
            try modelContext.delete(model: TransactionFile.self)
            try modelContext.delete(model: AppSettings.self)
            try modelContext.delete(model: TransactionTag.self)
            try modelContext.delete(model: RecurringTransaction.self)
            try modelContext.delete(model: RecurringTransactionGroup.self)
        } catch {
            print("Failed to clear all data.")
        }
    }
}

#Preview {
    SettingsView()
}
