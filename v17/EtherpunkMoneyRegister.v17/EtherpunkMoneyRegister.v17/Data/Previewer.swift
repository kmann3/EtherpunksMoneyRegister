//
//  Previewer.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 8/7/26.
//

import Foundation
import SQLite
import SwiftUI
import UUIDV7
#if os(macOS)
import AppKit
import UniformTypeIdentifiers
#endif

#if os(macOS)
fileprivate final class DevFileAccess {
    static let shared = DevFileAccess()
    private let bookmarkKey = "DevTestDBBookmark"

    func urlForTestDB(promptMessage: String = "Select your tmpData.sqlite3 file") -> URL? {
        // Try to resolve a previously stored security-scoped bookmark
        if let data = UserDefaults.standard.data(forKey: bookmarkKey) {
            var stale = false
            do {
                let url = try URL(resolvingBookmarkData: data,
                                   options: [.withSecurityScope],
                                   relativeTo: nil,
                                   bookmarkDataIsStale: &stale)
                if !stale {
                    return url
                } else {
                    UserDefaults.standard.removeObject(forKey: bookmarkKey)
                }
            } catch {
                // Failed to resolve; drop bookmark and fall through to prompt
                UserDefaults.standard.removeObject(forKey: bookmarkKey)
            }
        }

        // Prompt the user to select the file once
        let panel = NSOpenPanel()
        panel.title = "Choose SQLite file"
        panel.message = promptMessage
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false

        if #available(macOS 12.0, *) {
            let exts = ["sqlite", "sqlite3", "db"]
            let types = exts.compactMap { UTType(filenameExtension: $0) }
            if !types.isEmpty {
                panel.allowedContentTypes = types
            } else {
                panel.allowedFileTypes = exts
            }
        } else {
            panel.allowedFileTypes = ["sqlite", "sqlite3", "db"]
        }

        NSApp.activate(ignoringOtherApps: true)
        let response = panel.runModal()
        guard response == .OK, let url = panel.url else { return nil }

        // Store security-scoped bookmark for next time
        do {
            let bookmark = try url.bookmarkData(options: [.withSecurityScope],
                                                includingResourceValuesForKeys: nil,
                                                relativeTo: nil)
            UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        } catch {
            // If bookmarking fails, still return the URL for immediate use
        }
        return url
    }
}
#endif

@MainActor
class Previewer {
    public let bankAccount: Account = Account(
        id: UUIDV7(uuidString: "00000000-0000-7000-A000-000000000000")!,
        name: "Fake Bank",
        startingBalance: 2062.00,
        currentBalance: 2062.00,
        outstandingBalance: 0.0,
        outstandingItemCount: 0,
        notes: "",
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
    public var incomeRecurringTransaction: RecurringTransaction

    // Fake Recurring TRansactions that are intermentent
    public var pestControlRecurringTransaction: RecurringTransaction

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
        billGroup = RecurringGroup(name: "Monthly Bills")
        
        var daysAway: Int = -21

        // BURGER KING
        burgerKingTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Burger King",
            transactionType: .debit,
            amount: -12.39,
            transactionTags: [ffTag],
            //clearedOnUTC: Date().addingTimeInterval(-1_000_000)
            clearedOnUTC: Date().addDays(day: daysAway)
        )
        
        burgerKingTransaction.changeLogs = ("\(Date().toSummaryDateyyyyMMddHHmmSS()) - Created by System\n")
        burgerKingTransaction.changeLogs.append("\(Date().toSummaryDateyyyyMMddHHmmSS()) - Modify\n\tname: prev: McDonand's, new: Burger King\n\tamount: prev: 12.39, new: -12.39\n\ttags: prev: [], new: [fast-food]\n")
        
        daysAway += 2

        // CVS
        cvsTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "CVS",
            transactionType: .debit,
            amount: -88.34,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            fileCount: 1,
            transactionTags: [medicalTag, pharmacyTag],
            pendingOnUTC: Date().addDays(day: daysAway),
            clearedOnUTC: Date().addDays(day: daysAway),
            balancedOnUTC: Date().addDays(day: daysAway)
        )
        
        daysAway += 1

        // DISCORD
        discordRecurringTransaction = RecurringTransaction(
            name: "Discord2a",
            transactionType: .debit,
            amount: -13.99,
            defaultAccountId: bankAccount.id,
            transactionTags: [billsTag],
            recurringGroup: billGroup,
            frequency: .monthly,
            frequencyValue: 16
        )

        discordTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Discord",
            transactionType: .debit,
            amount: -10.81,
            notes: "Some test notes",
            confirmationNumber: "1mamz9Zvnz94n",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransactionId: discordRecurringTransaction.id,
            pendingOnUTC: Date().addDays(day: daysAway),
            clearedOnUTC: Date().addDays(day: daysAway)
        )
        
        daysAway += 3

        discordRecurringTransaction.transactions = [discordTransaction]

        huluPendingTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Hulu",
            transactionType: .debit,
            amount: -23.41,
            notes: "",
            confirmationNumber: "1Z49C",
            isTaxRelated: true,
            transactionTags: [billsTag],
            pendingOnUTC: Date().addDays(day: daysAway),
            clearedOnUTC: nil
        )
        
        daysAway += 1

        // VERIZON
        verizonRecurringTransaction = RecurringTransaction(
            name: "Verizon2",
            transactionType: TransactionType.debit,
            amount: 104.00,
            defaultAccountId: bankAccount.id,
            notes: "",
            transactionTags: [billsTag],
            recurringGroup: billGroup,
            frequency: .monthly,
            frequencyValue: 28
        )
        
        verizonReservedTransaction = AccountTransaction(
            accountId: bankAccount.id,
            name: "Verizon",
            transactionType: .debit,
            amount: -104.00,
            notes: "",
            confirmationNumber: "",
            isTaxRelated: true,
            transactionTags: [billsTag],
            recurringTransactionId: verizonRecurringTransaction.id,
            dueDate: Date(),
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

        pestControlRecurringTransaction = RecurringTransaction(
            name: "Pest Control Inc",
            transactionType: TransactionType.debit,
            amount: 104.00,
            defaultAccountId: bankAccount.id,
            notes: "",
            transactionTags: [billsTag],
            recurringGroup: nil,
            frequency: .xmonths,
            frequencyValue: 3
        )

        incomeRecurringTransaction = RecurringTransaction(
            name: "My Job (being a super hero by night, professional gamer by day)",
            transactionType: TransactionType.credit,
            amount: 2145.00,
            defaultAccountId: bankAccount.id,
            notes: "",
            transactionTags: [incomeTag],
            recurringGroup: nil,
            frequency: .monthly,
            frequencyValue: 1
        )

        Task {
            let monkeyData = await downloadEtherpunkMonkeyAsync()
            if monkeyData != nil {
                cvsAttachmentFile.data = monkeyData!
            } else {
                DLog("Error generating attachment transaction - monkey logo")
            }
        }
    }

    func importTestRecurringData(modelContext: ModelContext) {
    #if os(macOS)
        guard let fileURL = DevFileAccess.shared.urlForTestDB(promptMessage: "Select tmpData.sqlite3 for import (dev only)") else {
            DLog("Test data could not be found to be imported: no file chosen")
            return
        }
        let started = fileURL.startAccessingSecurityScopedResource()
        defer { if started { fileURL.stopAccessingSecurityScopedResource() } }
        let path = fileURL.path(percentEncoded: false)
        DLog("Loading up recurring data from: \(path)")

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            DLog("Test data could not be found to be imported at \(path)")
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
            let accountIdCol = Expression<UUID>("AccountId")

            let accountTable = Table("Accounts")
            let accountIdCol2 = Expression<UUID>("Id")
            let accountNameCol2 = Expression<String>("Name")

            var accountDictionary = ["12345678-1234-1234-1234-123456789abc": bankAccount]
            for row in try db.prepare(accountTable) {
                let newId: UUIDV7 = UUIDV7(uuidString: row[accountIdCol2].uuidString)!
                let account: Account = Account(
                    id: newId,
                    name: row[accountNameCol2]
                )
                if account.name == "Chase" {
                    continue
                } else {
                    accountDictionary.updateValue(account, forKey: row[accountIdCol2].uuidString)
                    modelContext.insert(account)
                }
            }
            
            DLog("Database Location: \(modelContext.sqliteLocation)")
            try modelContext.save()


            billGroup.recurringTransactions = []

            for row in try db.prepare(recurringTransactionTable) {
                let newId: UUIDV7 = UUIDV7(uuidString: row[idCol].uuidString)!
                let recurringTransaction: RecurringTransaction = RecurringTransaction(
                    id: newId,
                    name: row[nameCol],
                    transactionType: row[transactionTypeCol] == "debit" ? TransactionType.debit : TransactionType.credit,
                    amount: Decimal.init(string: row[amountCol])!,
                    defaultAccountId: accountDictionary[row[accountIdCol].uuidString]?.id ?? bankAccount.id
                    )

                if(row[groupNameCol] != nil) {
                    if(row[groupNameCol] == "bills") {
                        recurringTransaction.recurringGroup = billGroup
                        //if recurringTransaction.name != "Discord" && recurringTransaction.name != "Verizon" {
                            // For some reason if I assign the transaction tags again it causes Swift to crash
                            recurringTransaction.transactionTags = [billsTag]
                        //}

                        billGroup.recurringTransactions.append(recurringTransaction)
                    } else {
                        // It's probably not a monthly bill - like an annual thing like Bitwarden or something
                    }
                } else {
                    recurringTransaction.recurringGroup = nil
                    recurringTransaction.transactionTags = []
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
                    DLog("Error parsing frequency: \(row[frequencyCol])")
                }

                if recurringTransaction.nextDueDate! < Date() {
                    try recurringTransaction.BumpNextDueDate()
                }

                switch row[nameCol] {
                case "Discord":
                    discordRecurringTransaction = recurringTransaction
                    //discordTransaction.recurringTransaction = recurringTransaction
                    discordTransaction.recurringTransactionId = recurringTransaction.id
                    discordRecurringTransaction.transactions = [discordTransaction]
                    Previewer.insertTransaction(account: bankAccount, transaction: discordTransaction, context: modelContext)
                    modelContext.insert(discordRecurringTransaction)
                    break
                case "Verizon":
                    verizonRecurringTransaction = recurringTransaction
                    //verizonReservedTransaction.recurringTransaction = recurringTransaction
                    verizonReservedTransaction.recurringTransactionId = recurringTransaction.id
                    Previewer.insertTransaction(account: bankAccount, transaction: verizonReservedTransaction, context: modelContext)
                    modelContext.insert(verizonRecurringTransaction)
                    break
                default:
                    modelContext.insert(recurringTransaction)
                    break
                }
                
                try modelContext.save()
            }

            try modelContext.save()
        } catch {
            DLog(error.localizedDescription)
        }
    #else
        DLog("importTestRecurringData is only available on macOS.")
        return
    #endif
    }

    private func calculateDateFromMMDD(mmdd: String) -> Date {
        // Expect string to be in mmdd format. For example January first would be 01/01
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
        "https://etherpunk.com/wp-content/uploads/2026/01/cropped-Etherpunk-Monkey_180.png"

        guard let url = URL(string: monkeyUrlString) else {
            DLog("Invalid URL for EtherpunkMonkey: \(monkeyUrlString)")
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
        
        var dayOffset: Int = -150
        for i in 1...100 {
            let newTran = burgerKingTransaction.Clone()
            newTran.createdOnUTC = Date().addDays(day: dayOffset)
            newTran.pendingOnUTC = Date().addDays(day: dayOffset)
            newTran.clearedOnUTC = Date().addDays(day: Int.random(in: 0..<3) + dayOffset)
            newTran.balancedOnUTC = Date().addDays(day: Int.random(in: 3..<6) + dayOffset)
            dayOffset += 1
            newTran.name = "Burger King Clone \(i.datatypeValue)"
            Previewer.insertTransaction(account: bankAccount, transaction: newTran, context: modelContext)
        }

        Previewer.insertTransaction(account: bankAccount, transaction: burgerKingTransaction, context: modelContext)
        Previewer.insertTransaction(account: bankAccount, transaction: cvsTransaction, context: modelContext)
        Previewer.insertTransaction(account: bankAccount, transaction: huluPendingTransaction, context: modelContext)

        modelContext.insert(cvsAttachmentFile)

        // Let's add some temp fake data

    #if os(macOS)
        // Defer to next run loop so a window exists and the panel can present cleanly.
        //DispatchQueue.main.async {
            self.importTestRecurringData(modelContext: modelContext)
        //}
    #else
        DLog("Skipping importTestRecurringData: macOS-only tool.")
    #endif


        modelContext.insert(billGroup)

        do {
            try modelContext.save()
        } catch {
            DLog(error.localizedDescription)
        }
    }
}

