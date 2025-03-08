//
//  AccountTransactionViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/23/25.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionDetailsView {

    @MainActor
    @Observable
    class ViewModel {
        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var tran: AccountTransaction
        var files: [TransactionFile] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction) {
            self.dataSource = dataSource

            self.tran = tran
            self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
        }


        func addNewDocument() {

        }

        func addNewPhoto() {

        }
    }
}
