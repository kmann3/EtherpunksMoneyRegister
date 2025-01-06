//
//  Previewer.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SQLite
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
    public var discordRecurringTransaction: RecurringTransaction
    public var verizonRecurringTransaction: RecurringTransaction

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
            id: UUID(uuidString: "75696d00-50a8-40af-8c00-14b5e4245920")!,
            name: "Discord",
            transactionType: .debit,
            amount: 13.99,
            transactionTags: [billsTag],
            recurringGroup: billGroup,
            frequency: .monthly,
            frequencyValue: 16
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
            pendingOnUTC: Date(),
            clearedOnUTC: nil
        )
        container.mainContext.insert(huluPendingTransaction)

        // VERIZON
        verizonRecurringTransaction = RecurringTransaction(
            id: UUID(uuidString: "12283638-eaa1-4689-85dd-7b542ca55ecb")!,
            name: "Verizon",
            transactionType: TransactionType.debit,
            amount: 104.00,
            notes: "",
            transactionTags: [billsTag],
            recurringGroup: billGroup,
            frequency: .monthly,
            frequencyValue: 28
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

        discordRecurringTransaction.nextDueDate = getNextDueDate(day: 16)
        verizonRecurringTransaction.nextDueDate = getNextDueDate(day: 28)

        importTestRecurringData()

        container.mainContext.insert(billGroup)

        do {
            try container.mainContext.save()
        } catch {
            debugPrint(error)
        }

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

    func importTestRecurringData() {
        let path = "/Users/kennithmann/Downloads/dev/tmpData.sqlite3"

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            debugPrint("Test data could not be found to be imported at \(path)")
            return
        }

        do {
            typealias Expression = SQLite.Expression
            let db = try Connection(path)

            let recurringTransactionTable = Table("RecurringTransaction")
            let idCol = Expression<UUID>("Id")
            let nameCol = Expression<String>("Name")
            let transactionTypeCol = Expression<String>("TransactionType")
            let amountCol = Expression<String>("Amount")
            let frequencyCol = Expression<String>("Frequency")
            let frequencyValueCol = Expression<Int?>("FrequencyValue")
            let frequencyDayOfWeekCol = Expression<String?>("FrequencyDayOfWeek")
            let frequencyDateCol = Expression<String?>("FrequencyDate")
            let groupNameCol = Expression<String?>("GroupName")

            billGroup.recurringTransactions = []

            for row in try db.prepare(recurringTransactionTable) {
                let recurringTransaction: RecurringTransaction = RecurringTransaction(
                    id: row[idCol],
                    name: row[nameCol],
                    transactionType: row[transactionTypeCol] == "debit" ? TransactionType.debit : TransactionType.credit,
                    amount: Decimal.init(string: row[amountCol])!
                    )

                if(row[groupNameCol] != nil) {
                    if(row[groupNameCol] == "bills") {
                        recurringTransaction.recurringGroup = billGroup
                        if recurringTransaction.name != "Discord" && recurringTransaction.name != "Verizon" {
                            // For some reason if I assign the transaction tags again it causes Swift to crash
                            recurringTransaction.transactionTags = [billsTag]
                        }
                        billGroup.recurringTransactions?.append(recurringTransaction)
                    }
                } else {
                    recurringTransaction.recurringGroup = nil
                    recurringTransaction.transactionTags = nil
                }

                switch(row[frequencyCol]) {
                case "xweekOnYDayOfWeek":
                    let x = Int(row[frequencyDayOfWeekCol]!)
                    let y = Int(row[frequencyValueCol]!)
                    recurringTransaction.frequency = .xweekOnYDayOfWeek
                    recurringTransaction.frequencyValue = y
                    recurringTransaction.frequencyDayOfWeek = DayOfWeek(rawValue: x!)
                    recurringTransaction.nextDueDate = calculateDueDateFromYWeekAndXDay(yWeek: y, xDay: x!)
                    break
                case "monthly":
                    recurringTransaction.frequency = .monthly
                    recurringTransaction.frequencyValue = Int(row[frequencyValueCol]!)
                    recurringTransaction.nextDueDate = getNextDueDate(day: row[frequencyValueCol]!)
                    break
                case "yearly":
                    recurringTransaction.frequency = .yearly
                    recurringTransaction.frequencyDateValue = calculateDateFromMMDD(mmdd: row[frequencyDateCol]!)
                    recurringTransaction.nextDueDate = recurringTransaction.frequencyDateValue
                    break
                default:
                    debugPrint("Error parsing frequency: \(row[frequencyCol])")
                }

                switch row[nameCol] {
                case "Discord":
                    discordRecurringTransaction = recurringTransaction
                    break
                case "Verizon":
                    verizonRecurringTransaction = recurringTransaction
                    break
                default:
                    container.mainContext.insert(recurringTransaction)
                    break
                }

                if recurringTransaction.nextDueDate != nil {
                    debugPrint("Name: \(recurringTransaction.name) Due Date: \(recurringTransaction.nextDueDate!)")
                }

                try container.mainContext.save()
            }
            

        } catch {
            debugPrint(error)
        }
    }

    private func calculateDateFromMMDD(mmdd: String) -> Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents(
            [.year, .month, .day], from: Date())
        
        let mm = mmdd.components(separatedBy: "/")[0]
        let dd = mmdd.components(separatedBy: "/")[1]

        let mmInt = Int(String(mm))
        let ddInt = Int(String(dd))

        components.month = mmInt
        components.day = ddInt

        let date = calendar.date(from: components)
        return date!
    }

    private func calculateDueDateFromYWeekAndXDay(yWeek: Int, xDay: Int) -> Date {
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 0, to: Date())
        let currentComponents = calendar.dateComponents([.year, .month], from: nextMonth!)
        let startOfMonth = calendar.date(from: currentComponents)
        let startWeekday = calendar.component(.weekday, from: startOfMonth!)
        var difference = (xDay - startWeekday + 7) % 7
        difference += (yWeek - 1) * 7
        return calendar.date(byAdding: .day, value: difference, to: startOfMonth!)!
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
        components.day = day

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
