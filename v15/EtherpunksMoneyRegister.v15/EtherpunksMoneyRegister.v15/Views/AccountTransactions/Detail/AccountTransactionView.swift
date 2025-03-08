//
//  AccountTransactionView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/23/25.
//

import SwiftUI

struct AccountTransactionView: View {
    var viewModel: ViewModel
    
    init(tran: AccountTransaction) {
        self.viewModel = ViewModel(tran: tran)
    }
    
    var body: some View {
        List {
            Text("Name: \(self.viewModel.tran.name)")
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
                                // router.navigateTo(route: .tag_Edit(tag: tag))
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
                            //                            router
                            //                                .navigateTo(
                            //                                    route:
                            //                                            .recurringTransaction_Details(
                            //                                                recTrans: self.viewModel
                            //                                                    .recurringTransaction!
                            //                                            )
                            //                                )
                        }
                }
            }
            
            if self.viewModel.tran.recurringTransaction?.recurringGroup != nil {
                HStack {
                    Text("Recurring Group: ")
                    Text(self.viewModel.tran.recurringTransaction!.recurringGroup!.name)
                        .onTapGesture {
                            //                            router
                            //                                .navigateTo(
                            //                                    route:
                            //                                            .recurringGroup_Details(
                            //                                                recGroup: self.viewModel
                            //                                                    .recurringGroup!
                            //                                            )
                            //                                )
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            //                        router
                            //                            .navigateTo(
                            //                                route:
                            //                                        .transaction_Edit(
                            //                                            transaction: viewModel.transaction
                            //                                        )
                            //                            )
                        } label: {
                            Label("Edit transaction - \(self.viewModel.tran.name)", systemImage: "pencil")
                        }
                        
                        Divider()
                        
                        Button {
                            viewModel.addNewDocument()
                        } label: {
                            Label("Attach file", systemImage: "doc")
                        }
                        Button {
                            viewModel.addNewPhoto()
                        } label: {
                            Label("Attach photo", systemImage: "photo")
                        }
                        
                        Divider()
                        
                        Button {} label: {
                            Label(
                                "Create Recurring Transaction",
                                systemImage: "repeat")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    AccountTransactionView(tran: Previewer().discordTransaction)
}
