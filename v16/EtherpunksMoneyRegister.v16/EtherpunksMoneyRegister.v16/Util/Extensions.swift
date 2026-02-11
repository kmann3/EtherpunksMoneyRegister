//
//  ext.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/29/24.
//

import Foundation
import SwiftData

extension Double {
    func toDecimal() -> Decimal {
        return Decimal(self)
    }
}

extension Decimal {

    static func fromDisplayString(_ string: String) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        if let number = formatter.number(from: string) {
            return number.decimalValue
        } else {
            return nil
        }
    }
    
    func toDouble() -> Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }

    func toDisplayString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}

extension Date? {
    /// Sat, Jan 11
    func toSummaryDateMMMDEEE() -> String {
        if self == nil {
            return "n/a"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d - EEE")
        return dateFormatter.string(from: self!)
    }

    /// Jan 11
    func toSummaryDateMMMDD() -> String {
        if self == nil {
            return "n/a"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")
        return dateFormatter.string(from: self!)
    }
}

extension Date {
    /// Sat, Jan 11
    func toSummaryDateMMMDEEE() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d - EEE")
        return dateFormatter.string(from: self)
    }

    /// Jan 11, 2025
    func toSummaryDateMMMDY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d y")
        return dateFormatter.string(from: self)
    }

    /// Jan 11
    func toSummaryDateMMMDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")
        return dateFormatter.string(from: self)
    }

    /// Jan 05 @ 08:31:50
    func toShortDetailString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd @ HH:mm:ss")
        return dateFormatter.string(from: self)
    }

    /// Sat, Jan 11, 2025 at 02:24:59 -0600
    func toDebugDateOld() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE, dd MMM yyyy HH:mm:ss.SSSZ")
        return dateFormatter.string(from: self)
    }
    
    /// Sat, Jan 11, 2025 at 02:24:59 -0600
    func toDebugDate() -> String {
        let posix = Locale(identifier: "en_US_POSIX")

        // Sat, Jan 11, 2025
        let datePart = self.formatted(
            .dateTime
                .locale(posix)
                .weekday(.abbreviated)
                .month(.abbreviated)
                .day(.twoDigits)
                .year(.defaultDigits)
        )

        // 02:24:59 (24-hour, no AM/PM)
        let timePart = self.formatted(
            .dateTime
                .locale(posix)
                .hour(.twoDigits(amPM: .abbreviated))
                .minute(.twoDigits)
                .second(.twoDigits)
        )

        // -0600
        let offset = Self.numericGMTOffset(for: self)

        return "\(datePart) at \(timePart) \(offset)"
    }
    
    func toIdDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd.HH.mm.ss.SSS"
        return dateFormatter.string(from: self)
    }
    
    private static func numericGMTOffset(for date: Date) -> String {
        let seconds = TimeZone.current.secondsFromGMT(for: date)
        let hours = seconds / 3600
        let minutes = abs(seconds / 60) % 60
        // Produces strings like -0600, +0530, +0000
        return String(format: "%+03d%02d", hours, minutes)
    }
}

extension NumberFormatter {
    static var localCurrencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.generatesDecimalNumbers = true
        formatter.usesGroupingSeparator = true
        return formatter
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
