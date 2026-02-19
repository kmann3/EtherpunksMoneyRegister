//
//  AccountTransactionEditView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import SwiftUI
import SwiftData

struct AccountTransactionEditView: View {
    @StateObject private var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    @Query(sort: \Account.name) private var allAccounts: [Account]
    @State private var showTagPicker = false

    init(_ tran: AccountTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(tran: tran))
        self.handler = handler
    }
    
    var body: some View {
        Form {
            Section() {
                LabeledContent("Account") {
                    Picker("Account", selection: $viewModel.draft.account) {
                        ForEach(allAccounts) { account in
                            Text(account.name).tag(account)
                        }
                    }
                    .pickerStyle(.menu)
                }
                TextField("Name", text: $viewModel.draft.name)
                Picker("Type", selection: Binding(
                    get: { self.viewModel.draft.transactionType },
                    set: { self.viewModel.draft.transactionType = $0 }
                )) {
                    Text("Debit").tag(TransactionType.debit)
                    Text("Credit").tag(TransactionType.credit)
                }
                TextField("Amount", text: $viewModel.draft.amountString)
                Toggle("Tax Related", isOn: $viewModel.draft.isTaxRelated)
                TextField("Confirmation #", text: $viewModel.draft.confirmationNumber)
                TextField("Notes", text: $viewModel.draft.notes, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section() {
                Toggle("Pending", isOn: $viewModel.draft.hasPending)
                if viewModel.draft.hasPending {
                    DatePicker("Pending On", selection: Binding(
                        get: { self.viewModel.draft.pendingOn ?? Date() },
                        set: { self.viewModel.draft.pendingOn = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                Toggle("Cleared", isOn: $viewModel.draft.hasCleared)
                if viewModel.draft.hasCleared {
                    DatePicker("Cleared On", selection: Binding(
                        get: { self.viewModel.draft.clearedOn ?? Date() },
                        set: { self.viewModel.draft.clearedOn = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                Toggle("Has Due Date", isOn: $viewModel.draft.hasDueDate)
                if viewModel.draft.hasDueDate {
                    DatePicker("Due Date", selection: Binding(
                        get: { self.viewModel.draft.dueDate ?? Date() },
                        set: { self.viewModel.draft.dueDate = $0 }
                    ), displayedComponents: [.date])
                }
            }

            LabeledContent("Tags") {
                if $viewModel.draft.tags.isEmpty {
                    Text("No tags selected")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.viewModel.draft.tags.sorted(by: { $0.name < $1.name })) { tag in
                                Text(tag.name)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.thinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            Button("Edit Tags") { showTagPicker = true }

            if let rec = viewModel.tran.recurringTransaction {
                HStack {
                    Text("Recurring:")
                    Button {
                        handler(.recurringTransaction_Edit(recTran: rec))
                    } label: {
                        Text(rec.name)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
            } else {
                // Give option to create a recurring transaction
            }
        }
        .navigationTitle("Edit Transaction")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    handler(.transaction_Detail(transaction: viewModel.tran))
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        self.viewModel.save()
                    }
                    handler(.transaction_Detail(transaction: viewModel.tran))
                }
                    .disabled(!self.viewModel.draft.isValid)
            }
        }
        .sheet(isPresented: $showTagPicker) {
            TagPickerView(
                initialSelection: self.viewModel.draft.tags,
                onDone: { newSelection in
                    self.viewModel.draft.tags = newSelection
                    showTagPicker = false
                },
                onCancel: {
                    showTagPicker = false
                }
            )
        }
        .frame(minWidth: 150, minHeight: 650)
    }
}

#Preview ("CVS (pending and cleared)") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.cvsTransaction) { action in print(action) }
        .modelContainer(MoneyDataSource.shared.modelContainer)
}

#Preview ("Verizon") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.verizonReservedTransaction) { action in print(action) }
        .modelContainer(MoneyDataSource.shared.modelContainer)
}

