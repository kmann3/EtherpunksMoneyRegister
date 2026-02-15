//
//  AccountTransactionDetailsViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData
import SwiftUI

extension AccountTransactionDetailsView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource

        var tran: AccountTransaction
        var files: [TransactionFile] = []

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, tran: AccountTransaction) {
            self.dataSource = dataSource

            self.tran = tran
            self.files = self.dataSource.fetchTransactionFiles(tran: self.tran)
        }

        func addNewDocument() {
            // TODO: Implement addNewDocument for AccountTransactionDetailsView
        }

        func addNewPhoto() {
            // TODO: Implement addNewPhoto for AccountTransactionDetailsView
        }
    }
}
