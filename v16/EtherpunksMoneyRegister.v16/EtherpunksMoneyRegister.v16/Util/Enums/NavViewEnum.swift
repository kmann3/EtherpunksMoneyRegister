//
//  NavViewEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import Foundation
import SwiftUI

enum NavView: Hashable, CaseIterable {
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
}
