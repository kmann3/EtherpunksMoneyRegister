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
class Previewer {

    let isDbInMemory: Bool = true

    private static let now: Date = Date()
    public let bankAccount: Account = Account(
        id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
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

    // Tags
    public let billsTag: TransactionTag
    public let ffTag: TransactionTag
    public let fuelTag: TransactionTag
    public let incomeTag: TransactionTag
    public let medicalTag: TransactionTag
    public let pharmacyTag: TransactionTag
    public let streamingTag: TransactionTag

    // Fake Transactions
    public let burgerKingTransaction: AccountTransaction
    public var cvsTransaction: AccountTransaction
    public var discordTransaction: AccountTransaction
    public var huluPendingTransaction: AccountTransaction
    public var verizonReservedTransaction: AccountTransaction

    // Fake Recurring Transactions
    public let billGroup: RecurringGroup
    public let discordRecurringTransaction: RecurringTransaction
    public let huluRecurringTransaction: RecurringTransaction
    public let verizonRecurringTransaction: RecurringTransaction

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
        if isDbInMemory {
            debugPrint("Database is in memory.")
        } else {
            debugPrint(
                "Database Location: \(container.mainContext.sqliteLocation)")
        }
        debugPrint("Generating fake data. This may take a little bit.")

        // Bank accounts
        container.mainContext.insert(bankAccount)

        // Tags
        billsTag = TransactionTag(name: "bills")
        ffTag = TransactionTag(name: "fast-food")
        fuelTag = TransactionTag(name: "fuel")
        incomeTag = TransactionTag(name: "income")
        medicalTag = TransactionTag(name: "medical")
        pharmacyTag = TransactionTag(name: "pharmacy")
        streamingTag = TransactionTag(name: "streaming")

        container.mainContext.insert(billsTag)
        container.mainContext.insert(ffTag)
        container.mainContext.insert(fuelTag)
        container.mainContext.insert(incomeTag)
        container.mainContext.insert(medicalTag)
        container.mainContext.insert(pharmacyTag)
        container.mainContext.insert(streamingTag)

        // Recurring Groups

        billGroup = RecurringGroup(name: "Bills")

        // Initial balance
        var balance: Decimal = 437.99

        // BURGER KING
        var transactionAmount: Decimal = -12.39
        balance = balance + transactionAmount
        burgerKingTransaction = AccountTransaction(
            account: bankAccount,
            name: "Burger King",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            transactionTags: [ffTag],
            clearedOnUTC: Date().addingTimeInterval(-1_000_000)
        )
        container.mainContext.insert(burgerKingTransaction)

        // CVS
        transactionAmount = -88.34
        balance = balance + transactionAmount
        cvsTransaction = AccountTransaction(
            account: bankAccount,
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
            clearedOnUTC: Date(),
            balancedOnUTC: Date()
        )
        container.mainContext.insert(cvsTransaction)

        // DISCORD
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
            account: bankAccount,
            name: "Discord",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransaction: discordRecurringTransaction,
            pendingOnUTC: Date(),
            clearedOnUTC: Date()
        )
        container.mainContext.insert(discordTransaction)

        discordRecurringTransaction.transactions = [discordTransaction]
        container.mainContext.insert(discordRecurringTransaction)

        // HULU
        huluRecurringTransaction = RecurringTransaction(
            name: "Hulu",
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
            account: bankAccount,
            name: "Hulu",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "",
            confirmationNumber: "1Z49C",
            isTaxRelated: true,
            transactionTags: [billsTag, streamingTag],
            recurringTransaction: huluRecurringTransaction,
            pendingOnUTC: Date(),
            clearedOnUTC: nil
        )
        container.mainContext.insert(huluPendingTransaction)
        container.mainContext.insert(huluRecurringTransaction)

        // VERIZON
        verizonRecurringTransaction = RecurringTransaction(
            name: "Verizon",
            transactionType: TransactionType.debit,
            amount: 104.00,
            notes: "",
            transactionTags: [billsTag],
            RecurringGroupId: billGroup.id,
            frequency: .monthly
        )

        transactionAmount = -103.37
        balance = balance + transactionAmount
        verizonReservedTransaction = AccountTransaction(
            account: bankAccount,
            name: "Verizon",
            transactionType: .debit,
            amount: transactionAmount,
            balance: balance,
            notes: "",
            confirmationNumber: "",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransaction: verizonRecurringTransaction,
            pendingOnUTC: nil,
            clearedOnUTC: nil
        )
        container.mainContext.insert(verizonReservedTransaction)

        container.mainContext.insert(createTransaction(name: "Test 1", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 2", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 3", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 4", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 5", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 6", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 7", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 8", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 9", account: bankAccount, amount: 5.37, pending: nil, cleared: nil))

        container.mainContext.insert(createTransaction(name: "Test 1", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 2", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 3", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 4", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 5", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 6", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 7", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 8", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))
        container.mainContext.insert(createTransaction(name: "Test 9", account: bankAccount, amount: 5.37, pending: Date(), cleared: nil))


        billGroup.recurringTransactions = [
            discordRecurringTransaction,
            huluRecurringTransaction,
            verizonRecurringTransaction,
        ]
        container.mainContext.insert(billGroup)

        downloadImageDataAsync(completion: { [self] data in
            if data != nil {
                let cvsAttachmentFile: TransactionFile = TransactionFile(
                    name: "Etherpunk Logo",
                    filename: "monkey.jpg",
                    notes:
                        "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.",
                    data: data!,
                    isTaxRelated: true,
                    accountTransaction: self.cvsTransaction
                )

                container.mainContext.insert(cvsAttachmentFile)
            } else {
                debugPrint("Error downloading monkey from URL")
            }
        })

        debugPrint("Done generating data at \(Date().toDebugDate())")
        debugPrint("Main account id: \(bankAccount.id.uuidString)")
    }

    func createTransaction(name: String, account: Account, amount: Decimal, pending: Date?, cleared: Date?) -> AccountTransaction {
        return AccountTransaction(
            account: account,
            name: name,
            transactionType: .debit,
            amount: amount,
            balance: 0,
            notes: "",
            confirmationNumber: "",
            isTaxRelated: false,
            transactionTags: [],
            recurringTransaction: nil,
            pendingOnUTC: pending,
            clearedOnUTC: cleared
        )
    }

    private func getNextDueDate(day: Int) -> Date {
        let calendar = Calendar.current

        let currentComponents = calendar.dateComponents(
            [.year, .month, .day], from: Date())

        var monthsToAdd = 0

        if currentComponents.day! > 16 {
            monthsToAdd = 1
        }

        var components = calendar.dateComponents(
            [.year, .month, .day], from: Date())
        components.month! += monthsToAdd
        components.day = 16

        let date = calendar.date(from: components)
        return date!
    }

    func downloadImageDataAsync(completion: @escaping (Data?) -> Void) {
        let monkeyUrlString =
            "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"

        guard let url = URL(string: monkeyUrlString) else {
            debugPrint("Invalid URL: \(monkeyUrlString)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                debugPrint(
                    "Error downloading image: \(error?.localizedDescription ?? "Unknown error")"
                )
                completion(nil)
                return
            }

            completion(data)
        }

        task.resume()
    }
}

extension ModelContext {
    var sqliteLocation: String {
        if let url = container.configurations.first?.url.path(
            percentEncoded: false)
        {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
