//
//  RecurringTransactionView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/19/26.
//

import SwiftUI

struct RecurringGroupListView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel()
        self.handler = handler
    }
    
    var body: some View {
        List {
            ForEach(self.viewModel.recurringGroupList) { group in
                Button {
                    handler(PathStore.Route.recurringGroup_Details(recGroup: group))
                } label: {
                    RecurringGroupItem(item: group)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(minWidth: 400, maxWidth: 500)
    }
    
}

#Preview {
    RecurringGroupListView() { action in DLog(action.description) }
}
