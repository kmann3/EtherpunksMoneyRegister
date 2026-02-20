//
//  RecurringFrequencyEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation

enum RecurringFrequency: String, Codable, CustomStringConvertible {
    case unknown
    case irregular
    case yearly
    case monthly
    case weekly
    case xdays
    case xmonths
    case xweekOnYDayOfWeek
    
    var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .irregular: return "Irregular"
        case .yearly: return "Yearly"
        case .monthly: return "Monthly"
        case .weekly: return "Weekly"
        case .xdays: return "X Days"
        case .xmonths: return "X Months"
        case .xweekOnYDayOfWeek: return "X Week on Y Day of Week"
        }
    }
}

