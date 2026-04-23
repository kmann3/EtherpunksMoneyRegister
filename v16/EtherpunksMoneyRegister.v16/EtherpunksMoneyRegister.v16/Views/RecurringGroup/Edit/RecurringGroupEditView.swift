// 
//  RecurringGroupEditView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import SwiftUI
import SwiftData

struct RecurringGroupEditView: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.modelContext) private var modelContext
    var handler: (PathStore.Route) -> Void

    @Query(sort: \RecurringTransaction.name) private var allRecurringTransactions: [RecurringTransaction]
    

    init(_ recurringGroup: RecurringGroup, isNew: Bool = false, _ handler: @escaping (PathStore.Route) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(recurringGroup: recurringGroup, isNew: isNew))
        self.handler = handler
    }
    
    var body: some View {
        Form {
            Section() {
                Text("TBI:  RecurringGroupEditView: \(self.viewModel.recurringGroup.name)")
                TextField("Name", text: $viewModel.draft.name)
                // List the selected ones
                // List the unselected ones
            }
        }
        .navigationTitle(self.viewModel.isNew ? "New RecurringGroup" : "Edit RecurringGroup: \(self.viewModel.draft.name)")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (self.viewModel.isNew) {
                        handler(.recurringGroup_List)
                    } else {
                        handler(.recurringGroup_Details(recGroup: self.viewModel.recurringGroup))
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        self.viewModel.save()
                    }
                    handler(.recurringGroup_Details(recGroup: self.viewModel.recurringGroup))
                }
                    .disabled(!self.viewModel.draft.isValid)
            }
        }
    }
}

#Preview ("Default") {
    RecurringGroupEditView(MoneyDataSource.shared.previewer.billGroup) { action in DLog(action.description) }
}
