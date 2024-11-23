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
    private static let now: Date = Date()
    public static let bankAccount: Account = Account(id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
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
    public let burgerKingTransaction: AccountTransaction
    public var cvsTransaction: AccountTransaction
    public let discordRecurringTransaction: RecurringTransaction
    public let billGroup: RecurringTransactionGroup

    init() {
        let schema = Schema([
            Account.self,
            AccountTransaction.self
//            TransactionFile.self,
//            AppSettings.self,
//            TransactionTag.self,
//            RecurringTransaction.self,
//            RecurringTransactionGroup.self,
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        container = try! ModelContainer(for: schema, configurations: config)

        print("-----------------")
        print(Date())
        print("-----------------")
        print("Database Location: \(container.mainContext.sqliteCommand)")
        print("Generating fake data. This may take a little bit.")

        billsTag = TransactionTag(name: "bills")
        medicalTag = TransactionTag(name: "medical")
        pharmacyTag = TransactionTag(name: "pharmacy")
        ffTag = TransactionTag(name: "fast-food")
        incomeTag = TransactionTag(name: "income")

        var balance: Decimal = 437.99

        billGroup = RecurringTransactionGroup(name: "Bills")

        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        burgerKingTransaction = AccountTransaction(
            accountId: Previewer.bankAccount.id,
            name: "Burger King",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            transactionTags: [ffTag],
            clearedOnUTC: Date()
        )


        transactionAmount = -88.34
        balance = balance + transactionAmount
        cvsTransaction = AccountTransaction(
            accountId: Previewer.bankAccount.id,
            name: "CVS",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            isTaxRelated: true,
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
            recurringTransactionGroupId: billGroup.id,
            frequency: .monthly
        )

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
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
