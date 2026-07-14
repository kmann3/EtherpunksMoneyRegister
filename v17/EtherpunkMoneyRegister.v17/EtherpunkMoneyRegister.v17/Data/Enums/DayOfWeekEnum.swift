//
//  DayOfWeekEnum.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
//

import Foundation

enum DayOfWeek: Int, Hashable, CaseIterable, Codable, CustomStringConvertible  {
    case sunday    = 1
    case monday    = 2
    case tuesday   = 3
    case wednesday = 4
    case thursday  = 5
    case friday    = 6
    case saturday  = 7
    
    var description: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}
