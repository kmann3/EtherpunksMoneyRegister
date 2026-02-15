//
//  AccountTransactionDetails.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import SwiftUI

struct AccountTransactionDetailsView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ tran: AccountTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tran: tran)
        self.handler = handler
    }

    var body: some View {
        List {
            // TODO: Make the whole role the button - not just the text on the right
            HStack {
                Text("Name: \(self.viewModel.tran.name)")
                Spacer()
                Button("Edit Transaction") {
                    handler(PathStore.Route.transaction_Edit(transaction: self.viewModel.tran))
                }
            }
            Text(
                "Type: \(self.viewModel.tran.transactionType == .debit ? "Debit" : "Credit")"
            )
            HStack {
                Text("Account: ")
                Button {
                    handler(PathStore.Route.account_Edit(account: self.viewModel.tran.account))
                } label: {
                    Text(
                        "\(self.viewModel.tran.account.name)"
                    )
                    .underline()
                    .foregroundColor(.blue)
                }
            }
            HStack {
                Text("Amount: ")
                Text(
                    self.viewModel.tran.amount.toDisplayString())
            }

            if self.viewModel.tran.transactionTags.count > 0 {
                HStack {
                    HStack {
                        Text("Tags: ")
                    }
                    ForEach(
                        self.viewModel.tran.transactionTags.sorted(by: {
                            $0.name < $1.name
                        })
                    ) { tag in
                        Button {
                            handler(PathStore.Route.tag_Details(tag: tag))
                        } label: {
                            Text(tag.name)
                                .underline()
                                .foregroundColor(.blue)
                                .padding(2)

                        }
                    }
                }
            }

            HStack {
                // TODO: Link to report on taxes?
                Text(
                    "Tax Related: \(self.viewModel.tran.isTaxRelated == true ? "Yes" : "No")"
                )
            }

            Text("Balanced On:  \(self.viewModel.tran.balancedOnUTC?.toShortDetailString() ?? "nil")")

            Text(
                "Transaction Status: \(self.viewModel.tran.transactionStatus.description)"
            )

            // Reserved > Pending > Recurring > Cleared
            // Red      > Yellow  > Blue      > Green

            Text("Pending: \(self.viewModel.tran.pendingOnUTC?.toShortDetailString() ?? "")")
                .background(self.viewModel.tran.backgroundColor)

            Text("Cleared: \(self.viewModel.tran.clearedOnUTC?.toShortDetailString() ?? "")")
                .background(self.viewModel.tran.backgroundColor)

            // Recurring Transaction

            if self.viewModel.tran.dueDate != nil {
                HStack {
                    Text("Due date: ")
                    Button {
                        if self.viewModel.tran.recurringTransaction != nil {
                            handler(PathStore.Route.recurringTransaction_Edit(recTran: self.viewModel.tran.recurringTransaction!))
                        } else {
                            debugPrint("error with recurring transaction")
                        }
                    } label: {
                        Text(
                            self.viewModel.tran.dueDate!,
                            format: .dateTime.month().day()
                        )
                        .underline()
                        .foregroundColor(.blue)
                    }
                }
            }

            if self.viewModel.tran.confirmationNumber != "" {
                HStack {
                    Text("Confirmation: ")
                    Text(self.viewModel.tran.confirmationNumber)
                }
            }

            if self.viewModel.tran.recurringTransaction != nil {
                HStack {
                    Text("Recurring Transaction: ")
                    Button() {
                        handler(PathStore.Route.recurringTransaction_Details(recTran: viewModel.tran.recurringTransaction!))
                    } label: {
                        Text(self.viewModel.tran.recurringTransaction!.name)
                            .underline()
                            .foregroundColor(.blue)
                            .padding(2)

                    }
                }

            } else {
                HStack {
                    Text("Reccuring Transaction: ")
                    Button() {
                        handler(PathStore.Route.recurringTransaction_Create_FromTran(tran: self.viewModel.tran))
                    } label: {
                        Text("Create Recurring Transaction")
                            .underline()
                            .foregroundColor(.blue)
                            .padding(2)

                    }
                }
            }

            if self.viewModel.tran.recurringTransaction?.recurringGroup != nil {
                HStack {
                    Text("Recurring Group: ")
                    Button {
                        if viewModel.tran.recurringTransaction!.recurringGroup != nil {
                            handler(PathStore.Route.recurringGroup_Details(recGroup: self.viewModel.tran.recurringTransaction!.recurringGroup!))
                        } else {
                            print("group not loaded")
                        }
                    } label: {
                        Text(self.viewModel.tran.recurringTransaction!.recurringGroup!.name)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
            } else {
                HStack {
                    Text("Recurring Group: None")
                }
            }

            if self.viewModel.tran.notes != "" {
                Text(self.viewModel.tran.notes)
            }

            Section(header: Text("Misc")) {
                Text("Balanced On:  \(self.viewModel.tran.createdOnUTC.toShortDetailString())")
                Text("ID: \(self.viewModel.tran.id)")
                Text("CreatedOn: \(self.viewModel.tran.createdOnUTC.toDebugDate())")
            }
            
            // TODO: Add direct link to adding files here? So they don't have to click edit and then click add?
            Section(header: Text("Files")) {
                Text("Files: \(self.viewModel.tran.fileCount)")

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
        .frame(width: 450)
    }
}

#Preview ("CVS") {
    AccountTransactionDetailsView(MoneyDataSource.shared.previewer.cvsTransaction) { action in print(action) }
}

#Preview ("Verizon") {
    AccountTransactionDetailsView(MoneyDataSource.shared.previewer.verizonReservedTransaction) { action in print(action) }
}

