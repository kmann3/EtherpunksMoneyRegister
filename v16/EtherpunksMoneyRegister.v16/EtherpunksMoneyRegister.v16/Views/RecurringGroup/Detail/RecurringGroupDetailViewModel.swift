// 
//  RecurringGroupDetailViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import Foundation
import SwiftData
import SwiftUI

extension RecurringGroupDetailView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource
        
        var group: RecurringGroup
        
        init(group: RecurringGroup, dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.group = group
        }
    }
}
