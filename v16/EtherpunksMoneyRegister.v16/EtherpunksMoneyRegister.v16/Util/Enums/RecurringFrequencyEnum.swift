//
//  RecurringFrequencyEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation

enum RecurringFrequency: String, Codable {
    case unknown
    case irregular
    case yearly
    case monthly
    case weekly
    case xdays
    case xmonths
    case xweekOnYDayOfWeek
}

