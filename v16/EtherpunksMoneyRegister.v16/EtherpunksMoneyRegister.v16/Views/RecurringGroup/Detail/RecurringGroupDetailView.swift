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

    init(_ recurringGroup: RecurringGroup, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(recurringGroup: recurringGroup)
        self.handler = handler
    }
    
    var body: some View {
        List {
            Section("General Information") {
                HStack {
                    Text("Name: \(self.viewModel.recurringGroup.name)")
                    Spacer()
                    Button("Edit Recurring Group") { handler(PathStore.Route.recurringGroup_Edit(recGroup: self.viewModel.recurringGroup)) }
                }
            }

            Section("Misc") {
                Text("Id: \(self.viewModel.recurringGroup.id)")
                Text("Created On: \(self.viewModel.recurringGroup.createdOnUTC.toDebugDate())")
            }
        }
        .frame(width: 450)
    }
    
}

#Preview {
    RecurringGroupDetailView(MoneyDataSource.shared.previewer.billGroup) { action in DLog(action.description) }
}
