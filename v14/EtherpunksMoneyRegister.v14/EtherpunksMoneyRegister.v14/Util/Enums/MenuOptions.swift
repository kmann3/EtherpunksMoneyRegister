//
//  MenuOptionsEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 11/18/24.
//

import Foundation
import SwiftUICore

enum MenuOptionsEnum: Int, CaseIterable {
    case dashboard
    case accounts
    case recurringTransactions
    case tags
    case reports
    case search
    case settings

    var title: String{
        switch self {
        case .dashboard: return "Dashboard"
        case .accounts: return "Accounts"
        case .recurringTransactions: return "Recurring"
        case .tags: return "Tags"
        case .reports: return "Reports"
        case .search: return "Search"
        case .settings: return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .dashboard: return "house"
        case .accounts: return "list.bullet"
        case .recurringTransactions: return "calendar"
        case .tags: return "tag"
        case .reports: return "chart.bar"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape"
        }
    }

    var action: some View {
        switch self {
        case .dashboard:             return AnyView(DashboardView())
        case .accounts:              return AnyView(AccountsView())
        case .recurringTransactions: return AnyView(RecurringTransactionsView())
        case .reports:               return AnyView(ReportsView())
        case .search:                return AnyView(SearchView())
        case .settings:              return AnyView(SettingsView())
        default:                     return AnyView(DashboardView())
        }
    }

    var tabId: String {
        switch self {
        case .dashboard: return "Tab.Dashboard"
        case .accounts: return "Tab.Accounts"
        case .recurringTransactions: return "Tab.RecurringTransactions"
        case .tags: return "Tab.Tags"
        case .reports: return "Tab.Reports"
        case .search: return "Tab.Search"
        case .settings: return "Tab.Settings"
        }
    }
}
