//
//  RecurringTransactionView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/19/26.
//

import SwiftUI

struct RecurringTransactionListView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel()
        self.handler = handler
    }
    
    var body: some View {
        List {
            Section("Credit") {
                ForEach(self.viewModel.recurringTransactionList.filter { $0.transactionType == .credit }) { tran in
                    Button {
                        handler(PathStore.Route.recurringTransaction_Details(recTran: tran))
                    } label: {
                        // Need to indicate deposit/credit
                        Text("\(tran.name)")
                    }
                    .buttonStyle(.plain)
                }
            }
            Section("Debit") {
                ForEach(self.viewModel.recurringTransactionList.filter { $0.transactionType == .debit }) { tran in
                    Button {
                        handler(PathStore.Route.recurringTransaction_Details(recTran: tran))
                    } label: {
                        // Need to indicate deposit/credit
                        Text("\(tran.name)")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    RecurringTransactionListView() { action in DLog(action.description) }
}
