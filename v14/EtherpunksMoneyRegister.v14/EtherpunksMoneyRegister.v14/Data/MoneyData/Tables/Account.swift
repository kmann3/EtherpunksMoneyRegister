//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Account: ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var name: String = ""
    public var startingBalance: Decimal = 0
    public var currentBalance: Decimal = 0
    public var outstandingBalance: Decimal = 0
    public var outstandingItemCount: Int64 = 0
    public var notes: String = ""
    public var sortIndex: Int64 = 0
    public var lastBalancedUTC: Date? = nil
    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account) public var transactions: [AccountTransaction]? = nil
    public var transactionCount: Int64 = 0
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            Account:
            - id: \(id)
            - name: \(name)
            - startingBalance: \(startingBalance)
            - currentBalance: \(currentBalance)
            - oustandingBalance: \(outstandingBalance)
            - outstandingItemCount: \(outstandingItemCount)
            - notes: \(notes)
            - sortIndex: \(sortIndex)
            - lastBalancedUTC: \(lastBalancedUTC?.toDebugDate() ?? "nil")
            - transactions: (TBI - Summary?)
            - transactionCount: \(transactionCount)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }

    init(
        id: UUID,
        name: String = "",
        startingBalance: Decimal = 0,
        currentBalance: Decimal = 0,
        outstandingBalance: Decimal = 0,
        outstandingItemCount: Int64 = 0,
        notes: String = "",
        sortIndex: Int64 = .max,
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
        self.sortIndex = sortIndex

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
            print("Failed to convert UTC string to Date object.")
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
            print("Failed to convert UTC string to Date object.")
        }

    }

    init(
        name: String = "",
        startingBalance: Decimal = 0,
        currentBalance: Decimal = 0,
        outstandingBalance: Decimal = 0,
        outstandingItemCount: Int64 = 0,
        notes: String = "",
        sortIndex: Int64 = .max,
        lastBalancedUTC: Date? = nil
    ) {
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.sortIndex = sortIndex
        self.lastBalancedUTC = lastBalancedUTC
    }

    init(
        id: UUID,
        name: String,
        startingBalance: Decimal,
        currentBalance: Decimal,
        outstandingBalance: Decimal,
        outstandingItemCount: Int64,
        notes: String,
        sortIndex: Int64,
        lastBalancedUTC: Date?
    ) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.sortIndex = sortIndex
        self.lastBalancedUTC = lastBalancedUTC
    }

    init(
        name: String,
        startingBalance: Decimal
    ) {
        self.name = name
        self.startingBalance = startingBalance
    }
}
