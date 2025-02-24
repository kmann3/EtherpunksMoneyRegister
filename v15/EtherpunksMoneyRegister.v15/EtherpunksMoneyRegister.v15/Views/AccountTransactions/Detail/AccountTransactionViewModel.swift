//
//  AccountTransactionViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/23/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource
        var pathStore: PathStore

        var tran: AccountTransaction

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore

            self.tran = tran
        }


        func addNewDocument() {

        }

        func addNewPhoto() {

        }
    }
}
