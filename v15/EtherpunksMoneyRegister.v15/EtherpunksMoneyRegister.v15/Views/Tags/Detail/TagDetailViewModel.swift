//
//  TagDetailViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/12/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TagDetailView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var tag: TransactionTag

        var transactions: [Transaction] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tag: TransactionTag) {
            self.dataSource = dataSource
            self.tag = tag

            // datasource.getTransactionsFromTag
        }
    }
}
