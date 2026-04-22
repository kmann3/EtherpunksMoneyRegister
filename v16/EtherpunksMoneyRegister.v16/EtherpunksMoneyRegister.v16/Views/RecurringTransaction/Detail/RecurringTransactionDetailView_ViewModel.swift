//
//  AccountDetailView_ViewModel.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

extension RecurringTransactionDetailView {
    @MainActor
    class ViewModel {
        private let dataSource: MoneyDataSource

        var recurringTransaction: RecurringTransaction

        init(dataSource: MoneyDataSource = MoneyDataSource.shared, recurringTransaction: RecurringTransaction) {
            self.dataSource = dataSource
            self.recurringTransaction = recurringTransaction
        }
    }
}
