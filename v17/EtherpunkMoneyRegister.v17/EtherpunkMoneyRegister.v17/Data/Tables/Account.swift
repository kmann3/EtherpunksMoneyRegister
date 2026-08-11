//
//  Account.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/12/26.
//

import Foundation
import SwiftData
import UUIDV7

@Model
final class Account: Identifiable, Hashable {
    public var id: UUIDV7 = UUIDV7()
    public var name: String {
        get { _name }
        set {
            _previousName = _name
            let cleaned = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            _name = cleaned
        }
    }
    private var _name: String = ""
    private var _previousName: String = ""
    public var startingBalance: Decimal = 0
    public var currentBalance: Decimal = 0
    public var outstandingBalance: Decimal = 0
    public var outstandingItemCount: Int64 = 0
    public var notes: String = ""
    public var lastBalancedUTC: Date? = nil
    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account) public var transactions: [AccountTransaction] = []
    public var transactionCount: Int64 = 0
    public var createdOnUTC: Date = Date()

    init(
        id: UUIDV7 = UUIDV7(),
        name: String = "",
        startingBalance: Decimal = 0,
        currentBalance: Decimal = 0,
        outstandingBalance: Decimal = 0,
        outstandingItemCount: Int64 = 0,
        notes: String = "",
        lastBalancedUTC: String,
        createdOnUTC: String
    ) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes

        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let utcDate = utcDateFormatter.date(from: lastBalancedUTC) {
            // Convert UTC Date to local time Date
            let localTimeInterval =
                utcDate.timeIntervalSinceReferenceDate
                + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
            self.lastBalancedUTC = Date(
                timeIntervalSinceReferenceDate: localTimeInterval)
        } else {
            debugPrint("Failed to convert UTC string to Date object.")
            self.lastBalancedUTC = nil
        }

        if let utcDate = utcDateFormatter.date(from: createdOnUTC) {
            // Convert UTC Date to local time Date
            let localTimeInterval =
                utcDate.timeIntervalSinceReferenceDate
                + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
            self.lastBalancedUTC = Date(
                timeIntervalSinceReferenceDate: localTimeInterval)
        } else {
            debugPrint("Failed to convert UTC string to Date object.")
        }
    }

    init(
        name: String = "",
        startingBalance: Decimal = 0,
        currentBalance: Decimal = 0,
        outstandingBalance: Decimal = 0,
        outstandingItemCount: Int64 = 0,
        notes: String = "",
        lastBalancedUTC: Date? = nil
    ) {
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalancedUTC = lastBalancedUTC
    }

    init(
        name: String,
        startingBalance: Decimal
    ) {
        self.name = name
        self.startingBalance = startingBalance
    }

    init(name: String) {
        self.name = name
    }

    init(id: UUIDV7, name: String) {
        self.name = name
    }

    init()
    {
    }
    
    public func difference() -> String {
        // Need to return an array of difference we can use for a solid UPDATE query
        // For example: ["name", "Foo"] which would be UPDATE Account SET name='foo' sort of thing?
        return "Prev: \(_previousName), New: \(_name)"
    }
}

@MainActor
extension Account: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            Account:
            - id: \(id)
            - name: \(_name) [prev: \(_previousName)]
            - startingBalance: \(startingBalance)
            - currentBalance: \(currentBalance)
            - oustandingBalance: \(outstandingBalance)
            - outstandingItemCount: \(outstandingItemCount)
            - notes: \(notes)
            - transactions: (TBI - Summary?)
            - transactionCount: \(transactionCount)
            """
    }
    
    public var shortDescription: String {
        return "Account: \(name) Bal: \(currentBalance)"
    }
}
