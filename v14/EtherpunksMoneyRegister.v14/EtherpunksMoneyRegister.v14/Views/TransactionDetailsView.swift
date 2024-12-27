//
//  TransactionDetailView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import QuickLook
import SwiftUI

struct TransactionDetailsView: View {
    var transactionItem: AccountTransaction
    var account: Account?
    var recurringTransactionItem: RecurringTransaction? = nil
    var recurringGroupItem: RecurringGroup? = nil
    var transactionFiles: [TransactionFile] = []

    @State var url: URL?

    init(transactionItem: AccountTransaction) {
        let p = Previewer()
        self.transactionItem = transactionItem
        self.account = p.bankAccount

        self.recurringTransactionItem = p.discordRecurringTransaction
        self.recurringGroupItem = p.billGroup
    }

    var body: some View {
        List {
            Text("Name: \(self.transactionItem.name)")
            Text("Type: \(self.transactionItem.transactionType == .debit ? "Debit" : "Credit")")
            Text("Account: \(self.account!.name)")
            HStack {
                Text("Amount: ")
                Text(self.transactionItem.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }

            if self.transactionItem.transactionTags != nil {
                VStack {
                    HStack {
                        Text("Tags: ")
                        Spacer()
                    }
                    ForEach(self.transactionItem.transactionTags!.sorted(by: { $0.name < $1.name })) { tag in
                        Text(tag.name)
                    }
                }
            }

            HStack {
                Text("Tax Related: \(self.transactionItem.isTaxRelated == true ? "Yes" : "No")")
            }

            HStack {
                if self.transactionItem.balancedOnUTC != nil {
                    Text("Balanced On: ")
                    Text(self.transactionItem.balancedOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.transactionItem.balancedOnUTC!, format: .dateTime.hour().minute().second())
                } else {
                    Text("Balanced On: nil")
                }
            }

            Text("Transaction Status: \(self.transactionItem.transactionStatus)")

            // Put an emoji here to have a popup to describe
            // Reserved > Pending > Recurring > Cleared
            // Red      > Yellow  > Blue      > Green

            if self.transactionItem.pendingOnUTC != nil {
                HStack {
                    Text("Pending: ")
                    Text(self.transactionItem.pendingOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.transactionItem.pendingOnUTC!, format: .dateTime.hour().minute().second())
                }.background(self.transactionItem.backgroundColor)
            } else {
                Text("Pending: ").background(self.transactionItem.backgroundColor)
            }

            if self.transactionItem.clearedOnUTC != nil {
                HStack {
                    Text("Cleared: ")
                    Text(self.transactionItem.clearedOnUTC!, format: .dateTime.month().day())
                    Text("@")
                    Text(self.transactionItem.clearedOnUTC!, format: .dateTime.hour().minute().second())
                }.background(self.transactionItem.backgroundColor)
            } else {
                Text("Cleared: ").background(self.transactionItem.backgroundColor)
            }

            // Recurring Transaction

            if self.transactionItem.dueDate != nil {
                HStack {
                    Text("Due date: ")
                    Text(self.transactionItem.dueDate!, format: .dateTime.month().day())
                }
            }

            if self.transactionItem.confirmationNumber != "" {
                HStack {
                    Text("Confirmation: ")
                    Text(self.transactionItem.confirmationNumber)
                }
            }

            if self.recurringTransactionItem != nil {
                HStack {
                    Text("Recurring Transaction: ")
                    Text(self.recurringTransactionItem!.name)
                }
            }

            if self.recurringGroupItem != nil {
                HStack {
                    Text("Recurring Group: ")
                    Text(self.recurringGroupItem!.name)
                }
            }

            Section(header: Text("Files")) {
                Text("Files: \(self.transactionItem.fileCount)")

                HStack {
                    Button(action: addNewDocument) {
                        Text("Add Document")
                    }

                    Spacer()

                    Button(action: addNewPhoto) {
                        Text("Add Photo")
                    }
                }

                if self.transactionFiles.count > 0 {
                    ForEach(self.transactionFiles) { file in
                        VStack(alignment: .leading) {
                            if file.name != file.filename {
                                HStack {
                                    Text("Name: \(file.name)")
                                }
                            }
                            HStack {
                                Button("Filename: \(file.filename)") {
                                    url = file.dataURL
                                }.quickLookPreview($url)
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

            if self.transactionItem.notes != "" {
                Section(header: Text("Notes")) {
                    Text(self.transactionItem.notes)
                }
            }
            Section(header: Text("Misc")) {
                HStack {
                    Text("Created On: ")
                    Text(self.transactionItem.createdOnUTC, format: .dateTime.month().day())
                    Text("@")
                    Text(self.transactionItem.createdOnUTC, format: .dateTime.hour().minute().second())
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        //                        path.append(NavData(navView: .transactionEditor, transaction: transactionItem))
                    } label: {
                        Label("Edit transaction", systemImage: "pencil")
                    }

                    Divider()

                    Button {
                        addNewDocument()
                    } label: {
                        Label("Attach file", systemImage: "doc")
                    }
                    Button {
                        addNewPhoto()
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
    }

    func addNewDocument() {}

    func addNewPhoto() {}
}

#Preview {
    let p = Previewer()
    TransactionDetailsView(transactionItem: p.discordTransaction)
}
