//
//  NavViewEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import Foundation
import SwiftUI

enum NavView: Hashable, CaseIterable, Codable, CustomStringConvertible  {
    case account_Create
    case account_Delete
    case account_Details
    case account_Edit
    case account_List

    case dashboard

    case recurringGroup_Create
    case recurringGroup_Delete
    case recurringGroup_Details
    case recurringGroup_Edit
    case recurringGroup_List

    case recurringTransaction_Create
    case recurringTransaction_Delete
    case recurringTransaction_Details
    case recurringTransaction_Edit
    case recurringTransaction_List

    case report_Tax

    case tag_Create
    case tag_Delete
    case tag_Detail
    case tag_Edit
    case tag_List

    case transaction_Create
    case transaction_Delete
    case transaction_Detail
    case transaction_Edit
    case transaction_List
    
    var description: String {
        switch self {
        case .account_Create: return "Account.Create"
        case .account_Delete: return "Account.Delete"
        case .account_Details: return "Account.Details"
        case .account_Edit: return "Account.Edit"
        case .account_List: return "Account.List"

        case .dashboard: return "Dashboard"

        case .recurringGroup_Create: return "RecurringGroup.Create"
        case .recurringGroup_Delete: return "RecurringGroup.Delete"
        case .recurringGroup_Details: return "RecurringGroup.Details"
        case .recurringGroup_Edit: return "RecurringGroup.Edit"
        case .recurringGroup_List: return "RecurringGroup.List"

        case .recurringTransaction_Create: return "RecurringTransaction.Create"
        case .recurringTransaction_Delete: return "RecurringTransaction.Delete"
        case .recurringTransaction_Details: return "RecurringTransaction.Details"
        case .recurringTransaction_Edit: return "RecurringTransaction.Edit"
        case .recurringTransaction_List: return "RecurringTransaction.List"

        case .report_Tax: return "Report.Tax"

        case .tag_Create: return "Tag.Create"
        case .tag_Delete: return "Tag.Delete"
        case .tag_Detail: return "Tag.Detail"
        case .tag_Edit: return "Tag.Edit"
        case .tag_List: return "Tag.List"

        case .transaction_Create: return "Transaction.Create"
        case .transaction_Delete: return "Transaction.Delete"
        case .transaction_Detail: return "Transaction.Detail"
        case .transaction_Edit: return "Transaction.Edit"
        case .transaction_List: return "Transaction.List"
        }
    }
}
