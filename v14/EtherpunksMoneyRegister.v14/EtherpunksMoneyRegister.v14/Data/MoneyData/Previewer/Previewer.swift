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

    let isDbInMemory: Bool = true

    private static let now: Date = Date()
    public let bankAccount: Account = Account(id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
                                              name: "Chase Bank",
                                              startingBalance: 1024.44,
                                              currentBalance: 437.99,
                                              outstandingBalance: 33.73,
                                              outstandingItemCount: 2,
                                              notes: "",
                                              sortIndex: Int64.max,
                                              lastBalancedUTC: "2024-09-12T17:40:31.594+0000",
                                              createdOnUTC: "2024-09-13T17:40:31.594+0000")

    public let container: ModelContainer

    public let billsTag: TransactionTag
    public let medicalTag: TransactionTag
    public let pharmacyTag: TransactionTag
    public let ffTag: TransactionTag
    public let incomeTag: TransactionTag
    public let streamingTag: TransactionTag

    // Fake Transactions
    public let burgerKingTransaction: AccountTransaction
    public var cvsTransaction: AccountTransaction
    public var huluPendingTransaction: AccountTransaction
    public var verizonReservedTransaction: AccountTransaction
    public var discordTransaction: AccountTransaction

    // Fake Recurring Transactions
    public let discordRecurringTransaction: RecurringTransaction
    public let huluRecurringTransaction: RecurringTransaction
    public let billGroup: RecurringGroup


    init() {
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            RecurringGroup.self,
            RecurringTransaction.self,
            TransactionFile.self,
            TransactionTag.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: isDbInMemory)
        container = try! ModelContainer(for: schema, configurations: config)

        debugPrint("-----------------")
        debugPrint(Date().toDebugDate())
        debugPrint("-----------------")
        if(isDbInMemory) {
            debugPrint("Database is in memory.")
        } else {
            debugPrint("Database Location: \(container.mainContext.sqliteLocation)")
        }
        debugPrint("Generating fake data. This may take a little bit.")

        billsTag = TransactionTag(name: "bills")
        medicalTag = TransactionTag(name: "medical")
        pharmacyTag = TransactionTag(name: "pharmacy")
        ffTag = TransactionTag(name: "fast-food")
        incomeTag = TransactionTag(name: "income")
        streamingTag = TransactionTag(name: "streaming")

        var balance: Decimal = 437.99

        billGroup = RecurringGroup(name: "Bills")

        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        burgerKingTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Burger King",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            transactionTags: [ffTag],
            clearedOnUTC: Date().addingTimeInterval(-1000000)
        )

        transactionAmount = -88.34
        balance = balance + transactionAmount
        cvsTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "CVS",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            fileCount: 1,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: Date(),
            clearedOnUTC: Date()
        )

        discordRecurringTransaction = RecurringTransaction(
            name: "Discord",
            transactionType: .debit,
            amount: 13.99,
            notes: "",
            transactionTags: [billsTag],
            RecurringGroupId: billGroup.id,
            frequency: .monthly
        )

        transactionAmount = -10.81
        balance = balance + transactionAmount
        discordTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Discord",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: Date(),
            clearedOnUTC: Date()
        )

        discordTransaction.recurringTransactionId = discordRecurringTransaction.id

        discordRecurringTransaction.transactions = [discordTransaction]

        huluRecurringTransaction = RecurringTransaction(
            name: "hulu",
            transactionType: TransactionType.debit,
            amount: 23.41,
            notes: "",
            transactionTags: [billsTag],
            RecurringGroupId: billGroup.id,
            frequency: .monthly
        )

        transactionAmount = -23.41
        balance = balance + transactionAmount
        huluPendingTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Hulu",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "",
            confirmationNumber: "1Z49C",
            isTaxRelated: true,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: Date(),
            clearedOnUTC: nil
        )

        huluPendingTransaction.recurringTransactionId = huluRecurringTransaction.id

        billGroup.recurringTransactions = [
            discordRecurringTransaction,
            huluRecurringTransaction
        ]


        transactionAmount = -103.37
        balance = balance + transactionAmount
        verizonReservedTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Verizon",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "",
            confirmationNumber: "",
            isTaxRelated: true,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: nil,
            clearedOnUTC: nil
        )

        //        bankAccount.transactions = [
        //            huluPendingTransaction,
        //            verizonReservedTransaction,
        //            burgerKingTransaction,
        //            discordTransaction,
        //            cvsTransaction
        //        ]

        container.mainContext.insert(bankAccount)
        container.mainContext.insert(billGroup)
        container.mainContext.insert(billsTag)
        container.mainContext.insert(ffTag)
        container.mainContext.insert(incomeTag)
        container.mainContext.insert(medicalTag)
        container.mainContext.insert(streamingTag)
        container.mainContext.insert(burgerKingTransaction)
        container.mainContext.insert(cvsTransaction)
        container.mainContext.insert(huluPendingTransaction)
        container.mainContext.insert(verizonReservedTransaction)
        container.mainContext.insert(discordTransaction)
        container.mainContext.insert(discordRecurringTransaction)
        container.mainContext.insert(huluRecurringTransaction)

        let monkeyURL: URL? = downloadImageFromURL()
        if monkeyURL == nil {
            print("An error downloading monkey?")
        } else {
            let cvsAttachmentFile: TransactionFile = TransactionFile(
                id: UUID(),
                name: "Etherpunk Logo",
                filename: "monkey.jpg",
                notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.",
                dataURL: monkeyURL!,
                isTaxRelated: true,
                transactionId: cvsTransaction.id,
                transaction: cvsTransaction
            )
            container.mainContext.insert(cvsAttachmentFile)
        }

        debugPrint("Done generating data at \(Date().toDebugDate())")
        debugPrint("Main account id: \(bankAccount.id.uuidString)")
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
            debugPrint("Invalid URL: \(monkeyUrlString)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                debugPrint("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try data.write(to: destinationURL)
                completion(destinationURL)
            } catch {
                debugPrint("Error saving image data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    private func downloadImageFromURL() -> URL? {
        let monkeyUrl = "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"
        
        guard let url = URL(string: monkeyUrl) else {
            debugPrint("Issue with URL from string")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            try data.write(to: destinationURL)
            return destinationURL
        } catch {
            debugPrint("Error downloading file: \(error)")
            return nil
        }
    }
}

extension ModelContext {
    var sqliteLocation: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
