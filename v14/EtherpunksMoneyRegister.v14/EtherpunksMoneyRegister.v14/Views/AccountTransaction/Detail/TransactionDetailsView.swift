//
//  TransactionDetailView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import QuickLook
import SwiftUI
import SwiftData

struct TransactionDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router
    @State var viewModel: ViewModel

    init(transaction: AccountTransaction) {
        viewModel = ViewModel(transaction: transaction)
    }

    var body: some View {
        List {
            Text("Name: \(self.viewModel.transaction.name)")
            Text("Type: \(self.viewModel.transaction.transactionType == .debit ? "Debit" : "Credit")")
            Text("Account: \(self.viewModel.account?.name ?? "Error loading account")")
            HStack {
                Text("Amount: ")
                Text(self.viewModel.transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }

            if self.viewModel.transaction.transactionTags != nil {
                VStack {
                    HStack {
                        Text("Tags: ")
                        Spacer()
                    }
                    ForEach(self.viewModel.transaction.transactionTags!.sorted(by: { $0.name < $1.name })) { tag in
                        Text(tag.name)
                    }
                }
            }

            HStack {
                Text("Tax Related: \(self.viewModel.transaction.isTaxRelated == true ? "Yes" : "No")")
            }

            HStack {
                if self.viewModel.transaction.balancedOnUTC != nil {
                    Text("Balanced On: ")
                    Text(self.viewModel.transaction.balancedOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.viewModel.transaction.balancedOnUTC!, format: .dateTime.hour().minute().second())
                } else {
                    Text("Balanced On: nil")
                }
            }

            Text("Transaction Status: \(self.viewModel.transaction.transactionStatus)")

            // Reserved > Pending > Recurring > Cleared
            // Red      > Yellow  > Blue      > Green

            if self.viewModel.transaction.pendingOnUTC != nil {
                HStack {
                    Text("Pending: ")
                    Text(self.viewModel.transaction.pendingOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.viewModel.transaction.pendingOnUTC!, format: .dateTime.hour().minute().second())
                }.background(self.viewModel.transaction.backgroundColor)
            } else {
                Text("Pending: ").background(self.viewModel.transaction.backgroundColor)
            }

            if self.viewModel.transaction.clearedOnUTC != nil {
                HStack {
                    Text("Cleared: ")
                    Text(self.viewModel.transaction.clearedOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.viewModel.transaction.clearedOnUTC!, format: .dateTime.hour().minute().second())
                }.background(self.viewModel.transaction.backgroundColor)
            } else {
                Text("Cleared: ").background(self.viewModel.transaction.backgroundColor)
            }

            // Recurring Transaction

            if self.viewModel.transaction.dueDate != nil {
                HStack {
                    Text("Due date: ")
                    Text(self.viewModel.transaction.dueDate!, format: .dateTime.month().day())
                }
            }

            if self.viewModel.transaction.confirmationNumber != "" {
                HStack {
                    Text("Confirmation: ")
                    Text(self.viewModel.transaction.confirmationNumber)
                }
            }

            if self.viewModel.recurringTransaction != nil {
                HStack {
                    Text("Recurring Transaction: ")
                    Text(self.viewModel.recurringTransaction!.name)
                        .onTapGesture {
                            router
                                .navigateTo(
                                    route:
                                            .recurringTransaction_Details(
                                                recTrans: self.viewModel.recurringTransaction!
                                            )
                                )
                        }
                }
            }

            if self.viewModel.recurringGroup != nil {
                HStack {
                    Text("Recurring Group: ")
                    Text(self.viewModel.recurringGroup!.name)
                        .onTapGesture {
                            router
                                .navigateTo(
                                    route:
                                            .recurringGroup_Details(
                                                recGroup: self.viewModel.recurringGroup!
                                            )
                                )
                        }
                }
            }

            Section(header: Text("Files")) {
                Text("Files: \(self.viewModel.transaction.fileCount)")

                HStack {
                    Button(action: viewModel.addNewDocument) {
                        Text("Add Document")
                    }

                    Spacer()

                    Button(action: viewModel.addNewPhoto) {
                        Text("Add Photo")
                    }
                }

                if self.viewModel.transactionFiles.count > 0 {
                    ForEach(self.viewModel.transactionFiles) { file in
                        VStack(alignment: .leading) {
                            if file.name != file.filename {
                                HStack {
                                    Text("Name: \(file.name)")
                                }
                            }
                            HStack {
                                Button("Filename: \(file.filename)") {
                                    viewModel.url = file.dataURL
                                }.quickLookPreview($viewModel.url)
                                Text("Filename: \(file.filename)")
                            }

                            HStack {
                                Text("Created On: ")
                                Text(file.createdOnUTC, format: .dateTime.month().day())
                                Text("@")
                                Text(file.createdOnUTC, format: .dateTime.hour().minute().second())
                            }

                            HStack {
                                Text("Tax Document: \(file.isTaxRelated == true ? "Yes" : "No")")
                            }

                            HStack {
                                Text("Notes: \(file.notes)")
                            }
                        }.padding()
                    }
                }
            }

            if self.viewModel.transaction.notes != "" {
                Section(header: Text("Notes")) {
                    Text(self.viewModel.transaction.notes)
                }
            }
            Section(header: Text("Misc")) {
                HStack {
                    Text("Created On: ")
                    Text(self.viewModel.transaction.createdOnUTC, format: .dateTime.month().day())
                    Text("@")
                    Text(self.viewModel.transaction.createdOnUTC, format: .dateTime.hour().minute().second())
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        router
                            .navigateTo(
                                route:
                                        .transaction_Edit(
                                            transaction: viewModel.transaction
                                        )
                            )
                    } label: {
                        Label("Edit transaction", systemImage: "pencil")
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
                        Label("Create Recurring Transaction", systemImage: "repeat")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .onAppear() {
            viewModel.loadData(modelContext: modelContext)
        }
    }
}

#Preview("Recurring") {
    let p = Previewer()
    TransactionDetailsView(transaction: p.discordTransaction)
        .modelContainer(p.container)
        .environment(PathStore())
}

#Preview("Cleared") {
    let p = Previewer()
    TransactionDetailsView(transaction: p.cvsTransaction)
        .modelContainer(p.container)
        .environment(PathStore())
}

#Preview("Pending") {
    let p = Previewer()
    TransactionDetailsView(transaction: p.huluPendingTransaction)
        .modelContainer(p.container)
        .environment(PathStore())
}

#Preview("Reserved") {
    let p = Previewer()
    TransactionDetailsView(transaction: p.verizonReservedTransaction)
        .modelContainer(p.container)
        .environment(PathStore())
}
