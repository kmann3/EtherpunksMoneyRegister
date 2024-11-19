//
//  NavViewEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import Foundation

enum NavView: Hashable {
    case accountList
    case accountCreator
    case accountEditor
    case accountDeletor

    case tagDetail
    case tagEditor
    
    case transactionList
    case transactionDetail
    case transactionCreator
    case transactionEditor
    
    case recurringTransactionDetail
    case recurringTransactionEditor
    case recurringTransactionList
    
    case recurringTransactionGroupDetail
    case recurringTransactionGroupEditor
    case recurringTransactionGroupList
}
