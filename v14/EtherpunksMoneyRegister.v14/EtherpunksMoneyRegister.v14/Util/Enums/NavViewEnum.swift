//
//  NavViewEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import Foundation
import SwiftUICore

enum NavView: Hashable, CaseIterable {
    case accountList
    case accountCreator
    case accountEditor
    case accountDeletor

    case RecurringTransactionDetail
    case RecurringTransactionEditor
    case RecurringTransactionList

    case RecurringGroupDetail
    case RecurringGroupEditor
    case RecurringGroupList

    case tagDetail
    case tagList
    case tagEditor
    
    case transactionList
    case transactionDetail
    case transactionCreator
    case transactionEditor

    // TODO: Associate correct views
    var action: some View {
        switch self {
        case .accountList: return AnyView(DashboardView())
        case .accountCreator: return AnyView(DashboardView())
        case .accountEditor: return AnyView(DashboardView())
        case .accountDeletor: return AnyView(DashboardView())
        }
    }
}
