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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RecurringTransactionListView() { action in DLog(action.description) }
}
