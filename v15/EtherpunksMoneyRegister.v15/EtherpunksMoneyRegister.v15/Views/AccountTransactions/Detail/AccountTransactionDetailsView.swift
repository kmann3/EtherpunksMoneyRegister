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
                    print("edit")
                }
            }
            Text(
                "Type: \(self.viewModel.tran.transactionType == .debit ? "Debit" : "Credit")"
            )
            Text(
                "Account: \(self.viewModel.tran.account?.name ?? "Error loading account")"
            )
            HStack {
                Text("Amount: ")
                Text(
                    self.viewModel.tran.amount,
                    format: .currency(
                        code: Locale.current.currency?.identifier ?? "USD"))
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
                    }
                }
            }
            
            HStack {
                Text(
                    "Tax Related: \(self.viewModel.tran.isTaxRelated == true ? "Yes" : "No")"
                )
            }
            
            HStack {
                if self.viewModel.tran.balancedOnUTC != nil {
                    Text("Balanced On: ")
                    Text(
                        self.viewModel.tran.balancedOnUTC!,
                        format: .dateTime.month().day())
                    Text("@")
                    Text(
                        self.viewModel.tran.balancedOnUTC!,
                        format: .dateTime.hour().minute().second())
                } else {
                    Text("Balanced On: nil")
                }
            }
            
            Text(
                "Transaction Status: \(self.viewModel.tran.transactionStatus)"
            )
            
            // Reserved > Pending > Recurring > Cleared
            // Red      > Yellow  > Blue      > Green
            
            if self.viewModel.tran.pendingOnUTC != nil {
                HStack {
                    Text("Pending: ")
                    Text(
                        self.viewModel.tran.pendingOnUTC!,
                        format: .dateTime.month().day())
                    Text("@")
                    Text(
                        self.viewModel.tran.pendingOnUTC!,
                        format: .dateTime.hour().minute().second())
                }.background(self.viewModel.tran.backgroundColor)
            } else {
                Text("Pending: ").background(
                    self.viewModel.tran.backgroundColor)
            }
            
            if self.viewModel.tran.clearedOnUTC != nil {
                HStack {
                    Text("Cleared: ")
                    Text(
                        self.viewModel.tran.clearedOnUTC!,
                        format: .dateTime.month().day())
                    Text("@")
                    Text(
                        self.viewModel.tran.clearedOnUTC!,
                        format: .dateTime.hour().minute().second())
                }.background(self.viewModel.tran.backgroundColor)
            } else {
                Text("Cleared: ").background(
                    self.viewModel.tran.backgroundColor)
            }
            
            // Recurring Transaction
            
            if self.viewModel.tran.dueDate != nil {
                HStack {
                    Text("Due date: ")
                    Text(
                        self.viewModel.tran.dueDate!,
                        format: .dateTime.month().day())
                }
                .onTapGesture {
                    handler(PathStore.Route.recurringTransaction_Edit(recTrans: viewModel.tran.recurringTransaction!))
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
                        .onTapGesture {
                            handler(PathStore.Route.recurringTransaction_Details(recTrans: viewModel.tran.recurringTransaction!))
                        }
                }
            } else {
                Button("Create Recurring Transaction") {
                    handler(PathStore.Route.recurringTransaction_Create_FromTrans(tran: self.viewModel.tran))
                }
            }

            if self.viewModel.tran.recurringTransaction?.recurringGroup != nil {
                HStack {
                    Text("Recurring Group: ")
                    Text(self.viewModel.tran.recurringTransaction!.recurringGroup!.name)
                        .onTapGesture {
                            if viewModel.tran.recurringTransaction!.recurringGroup != nil {
                                handler(PathStore.Route.recurringGroup_Details(recGroup: viewModel.tran.recurringTransaction!.recurringGroup!))
                            } else {
                                print("group not loaded")
                            }

                        }
                }
            }
            
            Section(header: Text("Files")) {
                Text("Files: \(self.viewModel.tran.fileCount)")
                
                HStack {
                    Button(action: viewModel.addNewDocument) {
                        Text("Add Document")
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.addNewPhoto) {
                        Text("Add Photo")
                    }
                }

                if self.viewModel.files.count > 0 {
                    ForEach(self.viewModel.files, id: \.self) { file in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Filename: \(file.filename)")
                                Button("View") {
                                    //viewModel.downloadFileForViewing(file: file)
                                }
                                //.quickLookPreview($viewModel.url)
                            }

                            HStack {
                                Text("Created On: ")
                                Text(
                                    file.createdOnUTC,
                                    format: .dateTime.month().day())
                                Text("@")
                                Text(
                                    file.createdOnUTC,
                                    format: .dateTime.hour().minute().second())
                            }

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
                //                if self.viewModel.transactionFiles.count > 0 {
                //                    ForEach(self.viewModel.transactionFiles) { file in
                //                        VStack(alignment: .leading) {
                //                            if file.name != file.filename {
                //                                HStack {
                //                                    Text("Name: \(file.name)")
                //                                }
                //                            }
                //                            HStack {
                //                                Text("Filename: \(file.filename)")
                //                                Button("View") {
                //                                    viewModel.downloadFileForViewing(file: file)
                //                                }.quickLookPreview($viewModel.url)
                //                            }
                //
                //                            HStack {
                //                                Text("Created On: ")
                //                                Text(
                //                                    file.createdOnUTC,
                //                                    format: .dateTime.month().day())
                //                                Text("@")
                //                                Text(
                //                                    file.createdOnUTC,
                //                                    format: .dateTime.hour().minute().second())
                //                            }
                //
                //                            HStack {
                //                                Text(
                //                                    "Tax Document: \(file.isTaxRelated == true ? "Yes" : "No")"
                //                                )
                //                            }
                //
                //                            HStack {
                //                                Text("Notes: \(file.notes)")
                //                            }
                //                        }.padding()
                //                    }
                //                }
                //            }
                
                if self.viewModel.tran.notes != "" {
                    Section(header: Text("Notes")) {
                        Text(self.viewModel.tran.notes)
                    }
                }
                Section(header: Text("Misc")) {
                    HStack {
                        Text("Created On: ")
                        Text(
                            self.viewModel.tran.createdOnUTC,
                            format: .dateTime.month().day())
                        Text("@")
                        Text(
                            self.viewModel.tran.createdOnUTC,
                            format: .dateTime.hour().minute().second())
                    }
                }
            }
        }
    }
}

#Preview {
    AccountTransactionDetailsView(tran: MoneyDataSource.shared.previewer.cvsTransaction) { _ in }
}
