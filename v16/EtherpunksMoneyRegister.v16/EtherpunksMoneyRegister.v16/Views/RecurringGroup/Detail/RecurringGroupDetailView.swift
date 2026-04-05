// 
//  RecurringGroupDetailView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import SwiftUI

struct RecurringGroupDetailView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ group: RecurringGroup, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(group: group)
        self.handler = handler
    }
    
    var body: some View {
        Text("TBI:  RecurringGroupDetailView: \(self.viewModel.group.name)")
        .frame(minWidth: 400, maxWidth: 500)
    }
    
}

#Preview {
    RecurringGroupDetailView(MoneyDataSource.shared.previewer.billGroup) { action in DLog(action.description) }
}
