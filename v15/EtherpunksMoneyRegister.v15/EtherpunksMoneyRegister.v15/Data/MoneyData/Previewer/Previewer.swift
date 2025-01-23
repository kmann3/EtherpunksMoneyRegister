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
    public let bankAccount: Account = Account(
        id: UUID(uuidString: "12345678-1234-1234-1234-123456789abc")!,
        name: "Chase Bank",
        startingBalance: 2062.00,
        currentBalance: 2062.00,
        outstandingBalance: 0.0,
        outstandingItemCount: 0,
        notes: "",
        sortIndex: 0, // Highest Priority, it should always float to the top.
        lastBalancedUTC: "2024-09-12T17:40:31.594+0000",
        createdOnUTC: "2024-09-13T17:40:31.594+0000")

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
    public let discordTransaction: AccountTransaction
    public let huluPendingTransaction: AccountTransaction
    public let verizonReservedTransaction: AccountTransaction

    // Fake Recurring Transactions
    public let billGroup: RecurringGroup
    public var discordRecurringTransaction: RecurringTransaction
    public var verizonRecurringTransaction: RecurringTransaction

    // Fake attachments

    public var cvsAttachmentFile: TransactionFile

    init() {

        // Tags
        billsTag = TransactionTag(name: "bills")
        ffTag = TransactionTag(name: "fast-food")
        fuelTag = TransactionTag(name: "fuel")
        incomeTag = TransactionTag(name: "income")
        medicalTag = TransactionTag(name: "medical")
        pharmacyTag = TransactionTag(name: "pharmacy")
        streamingTag = TransactionTag(name: "streaming")


        // Recurring Groups
        billGroup = RecurringGroup(name: "Bills")

        // BURGER KING
        burgerKingTransaction = AccountTransaction(
            account: bankAccount,
            name: "Burger King",
            transactionType: .debit,
            amount: -12.39,
            transactionTags: [ffTag],
            clearedOnUTC: Date().addingTimeInterval(-1_000_000)
        )

        // CVS
        cvsTransaction = AccountTransaction(
            account: bankAccount,
            name: "CVS",
            transactionType: .debit,
            amount: -88.34,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            fileCount: 1,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: Date(),
            clearedOnUTC: Date(),
            balancedOnUTC: Date()
        )

        // DISCORD
        discordRecurringTransaction = RecurringTransaction(
            id: UUID(uuidString: "75696d00-50a8-40af-8c00-14b5e4245920")!,
            name: "Discord",
            transactionType: .debit,
            amount: -13.99,
            transactionTags: [billsTag],
            recurringGroup: billGroup,
            frequency: .monthly,
            frequencyValue: 16
        )

        discordTransaction = AccountTransaction(
            account: bankAccount,
            name: "Discord",
            transactionType: .debit,
            amount: -10.81,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransaction: discordRecurringTransaction,
            pendingOnUTC: Date(),
            clearedOnUTC: Date()
        )

        discordRecurringTransaction.transactions = [discordTransaction]

        // HULU
        huluPendingTransaction = AccountTransaction(
            account: bankAccount,
            name: "Hulu",
            transactionType: .debit,
            amount: -23.41,
            notes: "",
            confirmationNumber: "1Z49C",
            isTaxRelated: true,
            pendingOnUTC: Date(),
            clearedOnUTC: nil
        )

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

        verizonReservedTransaction = AccountTransaction(
            account: bankAccount,
            name: "Verizon",
            transactionType: .debit,
            amount: -104.00,
            notes: "",
            confirmationNumber: "",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransaction: verizonRecurringTransaction,
            pendingOnUTC: nil,
            clearedOnUTC: nil
        )

        cvsAttachmentFile = TransactionFile(
            name: "Etherpunk Logo",
            filename: "monkey.jpg",
            notes: "My etherpunk logo, which is quite cool. A friend made it years ago. Some more text to take up notes space.",
            data: Data(),
            isTaxRelated: true,
            accountTransaction: self.cvsTransaction
        )
        
        Task {
            let monkeyData = await downloadEtherpunkMonkeyAsync()
            if monkeyData != nil {
                cvsAttachmentFile.data = monkeyData!
            } else {
                print("Error generating attachment transaction - monkey logo")
            }
        }

        discordRecurringTransaction.nextDueDate = getNextDueDate(day: 16)
        verizonRecurringTransaction.nextDueDate = getNextDueDate(day: 28)

        print("Done generating data at \(Date().toDebugDate())")
        print("Main account id: \(bankAccount.id.uuidString)")
    }

    func importTestRecurringData(modelContext: ModelContext) {
        let path = "/Users/kennithmann/Downloads/dev/tmpData.sqlite3"

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            print("Test data could not be found to be imported at \(path)")
            return
        }
//12345678-1234-1234-1234-123456789abc
//87654321-4321-4231-4321-987654321cba
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
            let accountIdCol = Expression<UUID>("AccountId")

            let accountTable = Table("Accounts")
            let accountIdCol2 = Expression<UUID>("Id")
            let accountNameCol2 = Expression<String>("Name")

            var accountDictionary = ["12345678-1234-1234-1234-123456789abc": bankAccount]
            for row in try db.prepare(accountTable) {
                let account: Account = Account(
                    id: row[accountIdCol2],
                    name: row[accountNameCol2]
                )
                if row[accountIdCol2].uuidString == "12345678-1234-1234-1234-123456789abc" {
                    continue
                } else {
                    accountDictionary.updateValue(account, forKey: row[accountIdCol2].uuidString)
                    modelContext.insert(account)
                }
            }
            
            try? modelContext.save()


            billGroup.recurringTransactions = []

            for row in try db.prepare(recurringTransactionTable) {
                let recurringTransaction: RecurringTransaction = RecurringTransaction(
                    id: row[idCol],
                    name: row[nameCol],
                    transactionType: row[transactionTypeCol] == "debit" ? TransactionType.debit : TransactionType.credit,
                    amount: Decimal.init(string: row[amountCol])!
                    )

                recurringTransaction.defaultAccount = accountDictionary[row[accountIdCol].uuidString] ?? bankAccount

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

//                    if getNextDueDate(day: row[frequencyValueCol]!) < Date() {
//                        try recurringTransaction.BumpNextDueDate()
//                    }
                    break
                case "yearly":
                    recurringTransaction.frequency = .yearly
                    recurringTransaction.frequencyDateValue = calculateDateFromMMDD(mmdd: row[frequencyDateCol]!)
                    recurringTransaction.nextDueDate = recurringTransaction.frequencyDateValue
                    break
                default:
                    print("Error parsing frequency: \(row[frequencyCol])")
                }

                if recurringTransaction.nextDueDate! < Date() {
                    try recurringTransaction.BumpNextDueDate()
                }

                switch row[nameCol] {
                case "Discord":
                    discordRecurringTransaction = recurringTransaction
                    break
                case "Verizon":
                    verizonRecurringTransaction = recurringTransaction
                    break
                default:
                    modelContext.insert(recurringTransaction)
                    break
                }

                try modelContext.save()
            }
            

        } catch {
            print(error)
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

    func downloadEtherpunkMonkeyAsync() async -> Data? {
        let monkeyUrlString =
        "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"

        guard let url = URL(string: monkeyUrlString) else {
            print("Invalid URL: \(monkeyUrlString)")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }

    static func insertTransaction(account: Account, transaction: AccountTransaction, context: ModelContext) {
        transaction.VerifySignage()
        account.currentBalance += transaction.amount
        if(transaction.clearedOnUTC == nil) {
            account.outstandingBalance += transaction.amount
            account.outstandingItemCount += 1
        }
        account.transactionCount += 1
        transaction.balance = account.currentBalance
        context.insert(transaction)
    }

    func commitToDb(_ modelContext: ModelContext) {
        modelContext.insert(bankAccount)
        modelContext.insert(billsTag)
        modelContext.insert(ffTag)
        modelContext.insert(fuelTag)
        modelContext.insert(incomeTag)
        modelContext.insert(medicalTag)
        modelContext.insert(pharmacyTag)
        modelContext.insert(streamingTag)
        Previewer.insertTransaction(account: bankAccount, transaction: burgerKingTransaction, context: modelContext)
        Previewer.insertTransaction(account: bankAccount, transaction: cvsTransaction, context: modelContext)
        Previewer.insertTransaction(account: bankAccount, transaction: discordTransaction, context: modelContext)
        modelContext.insert(discordRecurringTransaction)
        Previewer.insertTransaction(account: bankAccount, transaction: huluPendingTransaction, context: modelContext)
        modelContext.insert(verizonRecurringTransaction)
        Previewer.insertTransaction(account: bankAccount, transaction: verizonReservedTransaction, context: modelContext)

        modelContext.insert(cvsAttachmentFile)
        importTestRecurringData(modelContext: modelContext)

        modelContext.insert(billGroup)

        do {
            try modelContext.save()
        } catch {
            print(error)
        }
    }
}
