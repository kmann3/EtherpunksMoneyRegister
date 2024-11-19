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
    case search
    case reports
    case settings

    var title: String{
        switch self {
        case .dashboard: return "Dashboard"
        case .accounts: return "Accounts"
        case .recurringTransactions: return "Recurring Transactions"
        case .tags: return "Tags"
        case .search: return "Search"
        case .reports: return "Reports"
        case .settings: return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .dashboard: return "house"
        case .accounts: return "list.bullet"
        case .recurringTransactions: return "calendar"
        case .tags: return "tag"
        case .search: return "magnifyingglass"
        case .reports: return "chart.bar"
        case .settings: return "gearshape"
        }
    }

    var action: some View {
        switch self {
        case .dashboard: return AnyView(DashboardView())
        case .accounts: return AnyView(AccountsView())
        case .recurringTransactions: return AnyView(RecurringTransactionsView())
        case .tags: return AnyView(TagsView())
        case .search: return AnyView(SearchView())
        case .reports: return AnyView(ReportsView())
        case .settings: return AnyView(SettingsView())
        }
    }
}
