//
//  AccountTransactionEditView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import SwiftUI

struct AccountTransactionEditView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ tran: AccountTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tran: tran)
        self.handler = handler
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview ("CVS (pending and cleared)") {
    AccountTransactionDetailsView(MoneyDataSource.shared.previewer.cvsTransaction) { action in print(action) }
}

#Preview ("Verizon") {
    AccountTransactionDetailsView(MoneyDataSource.shared.previewer.verizonReservedTransaction) { action in print(action) }
}
