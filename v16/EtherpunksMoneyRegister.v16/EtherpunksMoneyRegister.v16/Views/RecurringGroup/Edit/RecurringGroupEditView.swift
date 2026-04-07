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

    //@Query(sort: \RecurringGroup.name) private var allRecurringGroups: [RecurringGroup]
    

    init(_ group: RecurringGroup, isNew: Bool = false, _ handler: @escaping (PathStore.Route) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(group: group, isNew: isNew))
        self.handler = handler
    }
    
    var body: some View {
        Form {
            Section() {
                Text("TBI:  RecurringGroupEditView: \(self.viewModel.group.name)")
                //LabeledContent("Account") {
                //Picker("", selection: $viewModel.draft.account) {
                //    ForEach(allAccounts) { account in
                //        Text(account.name).tag(account)
                //    }
                //}
                //.pickerStyle(.menu)
                //TextField("Name", text: $viewModel.draft.name)
                //Picker("Type", selection: Binding(
                //get: { self.viewModel.draft.transactionType },
                //set: { self.viewModel.draft.transactionType = $0 }
                //)) {
                //    Text("Debit").tag(TransactionType.debit)
                //    Text("Credit").tag(TransactionType.credit)
                //}
                //CurrencyFieldView(amount: $viewModel.draft.amount)
            
            }
        }
        .navigationTitle(self.viewModel.isNew ? "New RecurringGroup" : "Edit RecurringGroup: \(self.viewModel.draft.name)")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (self.viewModel.isNew) {
                        handler(.recurringGroup_List)
                    } else {
                        handler(.recurringGroup_Details(recGroup: self.viewModel.group))
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        self.viewModel.save()
                    }
                    handler(.recurringGroup_Details(recGroup: self.viewModel.group))
                }
                    .disabled(!self.viewModel.draft.isValid)
            }
        }
        .frame(minWidth: 400, maxWidth: 500)
    }
}

#Preview ("Default") {
    RecurringGroupEditView(MoneyDataSource.shared.previewer.billGroup) { action in DLog(action.description) }
}
