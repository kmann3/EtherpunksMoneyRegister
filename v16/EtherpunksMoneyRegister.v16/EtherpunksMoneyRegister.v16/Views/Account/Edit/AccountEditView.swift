//
//  AccountEditView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/8/26.
//

import SwiftUI

struct AccountEditView: View {
    @StateObject private var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void
    var onSave: (() -> Void)?

    init(_ account: Account, isNewAccount: Bool = false, _ handler: @escaping (PathStore.Route) -> Void, onSave: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ViewModel(account: account, isNewAccount: isNewAccount))
        self.handler = handler
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Section() {
                TextField("Name", text: $viewModel.draft.name)
                CurrencyFieldView(amount: $viewModel.draft.startingBalance)
                
                TextField("Notes", text: $viewModel.draft.notes, axis: .vertical)
                    .lineLimit(3...6)
                
                LabeledContent("Last Balanced") {
                            DatePicker("",
                                       selection: Binding(
                                        get: { self.viewModel.draft.lastBalancedUTC ?? Date() },
                                        set: { self.viewModel.draft.lastBalancedUTC = $0 }
                                       ),
                                       displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .datePickerStyle(.field)
                }
            }
        }
        .navigationTitle(self.viewModel.isNewAccount ? "New Account" : "Edit Account: \(self.viewModel.draft.name)")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (self.viewModel.isNewAccount) {
                        handler(.dashboard)
                    } else {
                        handler(.transaction_List(account: self.viewModel.account))
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        self.viewModel.save()
                    }
                    onSave?()
                    handler(.transaction_List(account: self.viewModel.account))
                }
                .disabled(!self.viewModel.draft.isValid)
            }
        }
    }
}

#Preview("Fake Bank") {
    AccountEditView(MoneyDataSource.shared.previewer.bankAccount, isNewAccount: false) { action in DLog(action.description)}
}

#Preview("New Bank") {
    AccountEditView(Account(name: "ASD"), isNewAccount: true) { action in DLog(action.description)}
}
