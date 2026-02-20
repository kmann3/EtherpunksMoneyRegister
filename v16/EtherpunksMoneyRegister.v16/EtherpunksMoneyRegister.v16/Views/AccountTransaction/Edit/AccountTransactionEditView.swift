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
                LabeledContent("Pending") {
                    HStack(spacing: 8) {
                        Toggle("", isOn: $viewModel.draft.hasPending)
                            .labelsHidden()

                        if viewModel.draft.hasPending {
                            DatePicker("",
                                       selection: Binding(
                                           get: { self.viewModel.draft.pendingOn ?? Date() },
                                           set: { self.viewModel.draft.pendingOn = $0 }
                                       ),
                                       displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .datePickerStyle(.field)
                        }
                    }
                }

                LabeledContent("Cleared") {
                    HStack(spacing: 8) {
                        Toggle("", isOn: $viewModel.draft.hasCleared)
                            .labelsHidden()

                        if viewModel.draft.hasCleared {
                            DatePicker("",
                                       selection: Binding(
                                        get: { self.viewModel.draft.clearedOn ?? Date() },
                                           set: { self.viewModel.draft.clearedOn = $0 }
                                       ),
                                       displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .datePickerStyle(.field)
                        }
                    }
                }
                
                LabeledContent("Due Date") {
                    HStack(spacing: 8) {
                        Toggle("", isOn: $viewModel.draft.hasDueDate)
                            .labelsHidden()

                        if viewModel.draft.hasDueDate {
                            DatePicker("",
                                       selection: Binding(
                                        get: { self.viewModel.draft.dueDate ?? Date() },
                                           set: { self.viewModel.draft.dueDate = $0 }
                                       ),
                                       displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .datePickerStyle(.field)
                        }
                    }
                }
                
                LabeledContent("Balanced On") {
                    HStack(spacing: 8) {
                        Toggle("", isOn: $viewModel.draft.hasBalanced)
                            .labelsHidden()
                            .onChange(of: viewModel.draft.hasBalanced) {
                                // The only one we're skipping is if it's toggled AND the balancedOn has a value - we don't want to update the value, thus we are skipping it
                                if self.viewModel.draft.hasBalanced == true && self.viewModel.tran.balancedOnUTC == nil {
                                    // Only update the value if it never had one in the first place.
                                    self.viewModel.draft.balancedOn = Date()
                                } else if self.viewModel.draft.hasBalanced == false && self.viewModel.tran.balancedOnUTC == nil {
                                    // If it was never balanced, then make sure it stays that way
                                    self.viewModel.draft.balancedOn = nil
                                } else if self.viewModel.draft.hasBalanced == false && self.viewModel.tran.balancedOnUTC != nil {
                                    self.viewModel.draft.balancedOn = nil
                                }
                            }

                        if viewModel.draft.hasBalanced {
                            Text("  \(self.viewModel.tran.createdOnUTC.toShortDetailString())")
                            .labelsHidden()
                            .datePickerStyle(.field)
                        }
                    }
                }

            }

            LabeledContent("Tags") {
                if $viewModel.draft.tags.isEmpty {
                    Text("No tags selected")
                        .foregroundStyle(.secondary)
                } else {
                    // TODO: Consider making floating pill visual instead
                    // Where the selected ones float to the top, alphabetically
                    // And unselected and below it, alphabetically
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(self.viewModel.draft.tags.sorted(by: { $0.name < $1.name })) { tag in
                                Text(tag.name)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                Button("Edit Tags") { showTagPicker = true }
                Spacer()
            }
            
            LabeledContent("Recurring") {
                if let rec = viewModel.tran.recurringTransaction {
                    Button {
                        handler(.recurringTransaction_Edit(recTran: rec))
                    } label: {
                        Text(rec.name)
                            .underline()
                            .foregroundColor(.blue)
                    }
                } else {
                    HStack {
                        Text("None")
                        Button {
                            // TODO: Implement attach recurring?
                        } label: {
                            Text("Create")
                        }
                    }
                }
            }
            
            LabeledContent("Recurring Group") {
                if let recGroup = viewModel.tran.recurringTransaction?.recurringGroup {
                    Button {
                        handler(.recurringGroup_Edit(recGroup: recGroup))
                    } label: {
                        Text(recGroup.name)
                            .underline()
                            .foregroundColor(.blue)
                    }
                } else {
                    if let rec = viewModel.tran.recurringTransaction {
                        Text("Attach to: \(rec.name)")
                        Button {
                            // TODO: Implement attach recurring?
                        } label: {
                            Text("Create")
                        }
                    } else {
                        Text("None")
                    }
                }
            }

            LabeledContent("Files") {
                VStack {
                    HStack {
                        Text("Count: \(self.viewModel.tran.fileCount)")
                        Spacer()
                    }

                    if self.viewModel.files.count > 0 {
                        ForEach(self.viewModel.files, id: \.self) { file in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Filename: \(file.filename)")
                                    Button("View") {
                                        if file.data == nil {
                                            print("File \(file.filename) has no data")
                                        } else {
                                            QuickLookPreviewController().showPreview(for: file.data!, fileName: file.filename)
                                            
                                            // TODO: we need to purge temp files
                                        }
                                    }
                                }
                                
                                Text("Size: \(file.getFormattedFileSize())")
                                Text("Created On:  \(file.createdOnUTC.toShortDetailString())")
                                
                                HStack {
                                    Text(
                                        "Tax Document: \(file.isTaxRelated == true ? "Yes" : "No")"
                                    )
                                }
                                
                                HStack {
                                    Text("Notes: \(file.notes)")
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            
            Divider()
            
            LabeledContent("Created On") {
                Text("\(self.viewModel.tran.createdOnUTC.toDebugDate())")
            }
            LabeledContent("ID") {
                Text("\(self.viewModel.tran.id)")
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

#Preview ("CVS (pending and cleared) w Attachment") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.cvsTransaction) { action in print(action) }
        .modelContainer(MoneyDataSource.shared.modelContainer)
}

#Preview ("Verizon") {
    AccountTransactionEditView(MoneyDataSource.shared.previewer.verizonReservedTransaction) { action in print(action) }
        .modelContainer(MoneyDataSource.shared.modelContainer)
}

