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
    public static let bankAccount: Account = Account(id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
                                              name: "Chase Bank",
                                              startingBalance: 1024.44,
                                              currentBalance: 437.99,
                                              outstandingBalance: 33.73,
                                              outstandingItemCount: 2,
                                              notes: "",
                                              lastBalancedUTC: "2024-08-29 09:48:18 +0000",
                                              sortIndex: Int64.max,
                                              createdOnUTC: "2024-08-29 09:48:18 +0000",
                                              transactions: nil)
    public let billsTag: TransactionTag
    public let medicalTag: TransactionTag
    public let pharmacyTag: TransactionTag
    public let ffTag: TransactionTag
    public let incomeTag: TransactionTag
    public let burgerKingTransaction: AccountTransaction
    public var cvsTransaction: AccountTransaction
    public let discordRecurringTransaction: RecurringTransaction
    public let billGroup: RecurringTransactionGroup

    init() throws {
        billsTag = TransactionTag(name: "bills")
        medicalTag = TransactionTag(name: "medical")
        pharmacyTag = TransactionTag(name: "pharmacy")
        ffTag = TransactionTag(name: "fast-food")
        incomeTag = TransactionTag(name: "income")

        var balance: Decimal = 437.99

        billGroup = RecurringTransactionGroup(id: UUID(), name: "Bills", createdOnLocal: Date(), recurringTransactions: nil)

        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        burgerKingTransaction = AccountTransaction(id: UUID(), accountId: Previewer.bankAccount.id, name: "Burger King", transactionType: .debit, amount: transactionAmount, balance: balance, pendingLocal: nil, clearedLocal: Date(), notes: "", confirmationNumber: "", recurringTransactionId: nil, files: nil, transactionTags: [ffTag], isTaxRelated: false, dueDateLocal: nil, balancedOnLocal: Date(), createdOnLocal: Date())


        transactionAmount = -88.34
        balance = balance + transactionAmount
        cvsTransaction = AccountTransaction(id: UUID(), accountId: Previewer.bankAccount.id, name: "CVS", transactionType: .debit, amount: transactionAmount, balance: balance, pendingLocal: Date(), clearedLocal: nil, notes: "", confirmationNumber: "", recurringTransactionId: nil, files: nil, transactionTags: [medicalTag, pharmacyTag], isTaxRelated: true, dueDateLocal: nil, balancedOnLocal: Date(), createdOnLocal: Date())

        discordRecurringTransaction = RecurringTransaction(id: UUID(), name: "Discord", transactionType: .debit, amount: 13.99, notes: "", nextDueDate: nil, transactionTags: [billsTag], recurringTransactionGroupId: billGroup.id, transactions: nil, frequency: .unknown, frequencyValue: nil, frequencyDayOfWeek: nil, frequencyDateValue: nil, createdOnLocal: Date())
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
