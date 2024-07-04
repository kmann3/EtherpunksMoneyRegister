//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData

@Model
final class Account {
    var id: UUID = UUID()
    var name: String = ""
    var startingBalance: Decimal = 0
    var currentBalance: Decimal = 0
    var outstandingBalance: Decimal = 0
    var outstandingItemCount: Int = 0
    var notes: String = ""
    var lastBalanced: Date = Date()
    var sortIndex: Int = 255
    var createdOn: Date = Date()

    var transactionCount: Int = 0

    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]?

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, lastBalanced: Date = Date(), sortIndex: Int = 255, createdOn: Date = Date(), transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalanced = lastBalanced
        self.sortIndex = sortIndex
        self.createdOn = createdOn
        self.transactions = transactions

        if(transactions == nil || transactions!.isEmpty) {
            self.transactionCount = 0
        } else {
            self.transactionCount = transactions!.count
        }
    }

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, sortIndex: Int = 255) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
        self.outstandingBalance = 0
        self.outstandingItemCount = 0
        self.notes = ""
        self.lastBalanced = Date()
        self.sortIndex = sortIndex
        self.createdOn = Date()
        self.transactions = []
        self.transactionCount = 0
    }

    func RebalanceAccount(amount: Decimal, date: Date? = nil, modelContext: ModelContext) {

        if(self.transactionCount == 0) {
            print("Empty")
            return
        }

        let accountId: UUID = self.id

        var predicate: Predicate<AccountTransaction>

        if(date == nil) {
            // We probably changed the starting balance and need to readjust all transactions
            predicate = #Predicate<AccountTransaction> { transaction in
                if transaction.accountId == accountId {
                    return true
                } else {
                    return false
                }
            }
        } else {

            // We probably either adjusted the amount of an older transaction or moved one transaction to a new account
            predicate = #Predicate<AccountTransaction> { transaction in
                if transaction.accountId == accountId && transaction.createdOn >= date! {
                    return true
                } else {
                    return false
                }
            }
        }

        let fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
        DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    for transaction in newTransactions {
                        transaction.balance = transaction.balance + amount
                    }
                    try! modelContext.save()
                } catch {
                    DispatchQueue.main.async {
                        print("Error fetching transactions: \(error.localizedDescription)")
                    }
                }
        }
    }
}
