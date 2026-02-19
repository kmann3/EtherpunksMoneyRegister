//
//  AccountTransactionEditView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import SwiftUI
import SwiftData

struct AccountTransactionEditView: View {
    private var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    @State private var showTagPicker = false

    init(_ tran: AccountTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tran: tran)
        self.handler = handler
    }
    
    var body: some View {
        Form {
            Section("Basics") {
                TextField("Name", text: Binding(
                    get: { self.viewModel.draft.name },
                    set: { self.viewModel.draft.name = $0 }
                ))
                Picker("Type", selection: Binding(
                    get: { self.viewModel.draft.transactionType },
                    set: { self.viewModel.draft.transactionType = $0 }
                )) {
                    Text("Debit").tag(TransactionType.debit)
                    Text("Credit").tag(TransactionType.credit)
                }
                TextField("Amount", text: Binding(
                    get: { self.viewModel.draft.amountString },
                    set: { self.viewModel.draft.amountString = $0 }
                ))
                Toggle("Tax Related", isOn: Binding(
                    get: { self.viewModel.draft.isTaxRelated },
                    set: { self.viewModel.draft.isTaxRelated = $0 }
                ))
                TextField("Confirmation #", text: Binding(
                    get: { self.viewModel.draft.confirmationNumber },
                    set: { self.viewModel.draft.confirmationNumber = $0 }
                ))
                TextField("Notes", text: Binding(
                    get: { self.viewModel.draft.notes },
                    set: { self.viewModel.draft.notes = $0 }
                ), axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("Status") {
                Toggle("Pending", isOn: Binding(
                    get: { self.viewModel.draft.hasPending },
                    set: { self.viewModel.draft.hasPending = $0 }
                ))
                if viewModel.draft.hasPending {
                    DatePicker("Pending On", selection: Binding(
                        get: { self.viewModel.draft.pendingOn ?? Date() },
                        set: { self.viewModel.draft.pendingOn = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                Toggle("Cleared", isOn: Binding(
                    get: { self.viewModel.draft.hasCleared },
                    set: { self.viewModel.draft.hasCleared = $0 }
                ))
                if viewModel.draft.hasCleared {
                    DatePicker("Cleared On", selection: Binding(
                        get: { self.viewModel.draft.clearedOn ?? Date() },
                        set: { self.viewModel.draft.clearedOn = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                Toggle("Has Due Date", isOn: Binding(
                    get: { self.viewModel.draft.hasDueDate },
                    set: { self.viewModel.draft.hasDueDate = $0 }
                ))
                if viewModel.draft.hasDueDate {
                    DatePicker("Due Date", selection: Binding(
                        get: { self.viewModel.draft.dueDate ?? Date() },
                        set: { self.viewModel.draft.dueDate = $0 }
                    ), displayedComponents: [.date])
                }
            }

            Section("Tags") {
                if self.viewModel.draft.tags.isEmpty {
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
                Button("Edit Tags") { showTagPicker = true }
            }

            Section("Advanced") {
                HStack {
                    Text("Account:")
                    Button {
                        handler(.account_Edit(account: viewModel.tran.account))
                    } label: {
                        Text(viewModel.tran.account.name)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }

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
                }
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
                    self.viewModel.save()
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
                    // TODO: Ok, so tags come back but they aren't being shown. Need to fix
                    showTagPicker = false
                },
                onCancel: {
                    showTagPicker = false
                }
            )
        }
        .frame(minWidth: 150, minHeight: 550)
    }
}

#Preview ("CVS (pending and cleared)") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.cvsTransaction) { action in print(action) }
}

#Preview ("Verizon") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.verizonReservedTransaction) { action in print(action) }
}

