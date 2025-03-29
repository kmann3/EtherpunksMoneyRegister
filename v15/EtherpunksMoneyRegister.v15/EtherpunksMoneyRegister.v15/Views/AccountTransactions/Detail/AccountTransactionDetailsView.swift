//
//  AccountTransactionView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/23/25.
//

import SwiftUI

struct AccountTransactionDetailsView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(tran: AccountTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tran: tran)
        self.handler = handler
    }

    var body: some View {
        List {
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
                Text(
                    "\(self.viewModel.tran.account.name)"
                )
                .onTapGesture {
                    handler(PathStore.Route.account_Edit(account: self.viewModel.tran.account))
                }
                .underline()
                .foregroundColor(.blue)

            }
            HStack {
                Text("Amount: ")
                Text(
                    self.viewModel.tran.amount.toDisplayString())
            }
            
            if self.viewModel.tran.transactionTags != nil {
                VStack {
                    HStack {
                        Text("Tags: ")
                        Spacer()
                    }
                    ForEach(
                        self.viewModel.tran.transactionTags!.sorted(by: {
                            $0.name < $1.name
                        })
                    ) { tag in
                        Text(tag.name)
                            .onTapGesture {
                                handler(PathStore.Route.tag_Details(tag: tag))
                            }
                            .underline()
                            .foregroundColor(.blue)
                            .padding(2)
                    }
                }
            }
            
            HStack {
                Text(
                    "Tax Related: \(self.viewModel.tran.isTaxRelated == true ? "Yes" : "No")"
                )
                .onTapGesture {
                    handler(PathStore.Route.report_Tax)
                }
            }

            Text("Balanced On:  \(self.viewModel.tran.balancedOnUTC?.toShortDetailString() ?? "nil")")

            Text(
                "Transaction Status: \(self.viewModel.tran.transactionStatus)"
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
                    Text(
                        self.viewModel.tran.dueDate!,
                        format: .dateTime.month().day())
                    .underline()
                    .foregroundColor(.blue)
                }
                .onTapGesture {
                    if(self.viewModel.tran.recurringTransaction != nil) {
                        handler(PathStore.Route.recurringTransaction_Edit(recTran: self.viewModel.tran.recurringTransaction!))
                    } else {
                        debugPrint("error with recurring transaction")
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
                    Text(self.viewModel.tran.recurringTransaction!.name)
                        .underline()
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    handler(PathStore.Route.recurringTransaction_Details(recTran: viewModel.tran.recurringTransaction!))
                }

            } else {
                HStack {
                    Text("Reccuring Transaction: ")
                    Button("Create Recurring Transaction") {
                        handler(PathStore.Route.recurringTransaction_Create_FromTran(tran: self.viewModel.tran))
                    }
                }
            }

            if self.viewModel.tran.recurringTransaction?.recurringGroup != nil {
                HStack {
                    Text("Recurring Group: ")
                    Text(self.viewModel.tran.recurringTransaction!.recurringGroup!.name)
                        .underline()
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    if viewModel.tran.recurringTransaction!.recurringGroup != nil {
                        handler(PathStore.Route.recurringGroup_Details(recGroup: self.viewModel.tran.recurringTransaction!.recurringGroup!))
                    } else {
                        print("group not loaded")
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

                HStack {
                    Text("ID: \(self.viewModel.tran.id)")
                }
            }

            Section(header: Text("Files")) {
                Text("Files: \(self.viewModel.tran.fileCount)")

                if self.viewModel.files.count > 0 {
                    ForEach(self.viewModel.files, id: \.self) { file in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Filename: \(file.filename)")
                                Button("View") {
                                    //TODO: viewModel.downloadFileForViewing(file: file)
                                }
                                // TODO: .quickLookPreview($viewModel.url)
                            }

                            Text("Balanced On:  \(file.createdOnUTC.toShortDetailString())")

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

#Preview {
    AccountTransactionDetailsView(tran: MoneyDataSource.shared.previewer.cvsTransaction) { _ in }
}

#Preview {
    AccountTransactionDetailsView(tran: MoneyDataSource.shared.previewer.verizonReservedTransaction) { foo in
        print(foo.self as PathStore.Route)
    }
}
