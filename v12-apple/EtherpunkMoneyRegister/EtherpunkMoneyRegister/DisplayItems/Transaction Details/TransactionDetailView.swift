//
//  TransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import QuickLook
import SwiftUI

struct TransactionDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Bindable var transaction: AccountTransaction
    
    @State var url: URL?
    
    var body: some View {
        List {
            Text("Name: \(transaction.name)")
            Text("Type: \(transaction.transactionType == .debit ? "Debit" : "Credit")")
            Text("Account: \(transaction.account!.name)")
            HStack {
                Text("Amount: ")
                Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            if transaction.tags != nil {
                VStack {
                    HStack {
                        Text("Tags: ")
                        Spacer()
                    }
                    ForEach(transaction.tags!.sorted(by: { $0.name < $1.name })) { tag in
                        NavigationLink(value: NavData(navView: .tagDetail, tag: tag)) {
                            Text(tag.name)
                        }
                    }
                }
            }
            
            HStack {
                Text("Tax Related: \(transaction.isTaxRelated == true ? "Yes" : "No")")
            }
            
            if transaction.pending != nil {
                HStack {
                    Text("Pending: ")
                    Text(transaction.pending!, format: .dateTime.month().day())
                    Text("@")
                    Text(transaction.pending!, format: .dateTime.hour().minute().second())
                }.background(transaction.backgroundColor)
            } else {
                Text("Pending: ").background(transaction.backgroundColor)
            }
            
            if transaction.cleared != nil {
                HStack {
                    Text("Cleared: ")
                    Text(transaction.cleared!, format: .dateTime.month().day())
                    Text("@")
                    Text(transaction.cleared!, format: .dateTime.hour().minute().second())
                }.background(transaction.backgroundColor)
            } else {
                Text("Cleared: ").background(transaction.backgroundColor)
            }
            
            if transaction.recurringTransaction != nil {
                HStack {
                    Text("Recurring Transaction: ")
                    NavigationLink(value: NavData(navView: .recurringTransactionDetail, recurringTransaction: transaction.recurringTransaction!)) {
                        Text(transaction.recurringTransaction!.name)
                    }
                }
            }
            
            if transaction.recurringTransaction != nil && transaction.recurringTransaction?.group != nil {
                HStack {
                    Text("Recurring Transaction Group: ")
                    NavigationLink(value: NavData(navView: .recurringTransactionGroupDetail, recurringTransactionGroup: transaction.recurringTransaction!.group)) {
                        Text(transaction.recurringTransaction!.group!.name)
                    }
                }
            }
            
            Section(header: Text("Files")) {
                Text("Files: \(transaction.fileCount)")
                
                HStack {
                    Button(action: addNewDocument) {
                        Text("Add Document")
                    }
                    
                    Spacer()
                    
                    Button(action: addNewPhoto) {
                        Text("Add Photo")
                    }
                }
                
                if transaction.fileCount > 0 {
                    ForEach(transaction.files!.sorted(by: { $0.createdOn < $1.createdOn })) { file in
                        VStack(alignment: .leading) {
                            if file.name != file.filename {
                                HStack {
                                    Text("Name: \(file.name)")
                                }
                            }
                            HStack {
                                Button("Filename: \(file.filename)") {
                                    url = file.url
                                }.quickLookPreview($url)
                            }
                            HStack {
                                Text("Created On: ")
                                Text(file.createdOn, format: .dateTime.month().day())
                                Text("@")
                                Text(file.createdOn, format: .dateTime.hour().minute().second())
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
            
            // Expected due date
            // Confirmation
            // Notes
            // Recurring Transaction
            
            Section(header: Text("Misc")) {
                if transaction.bankTransactionText != "" {
                    HStack {
                        Text("Bank Text: \(transaction.bankTransactionText)")
                    }
                }
                
                HStack {
                    Text("Created On: ")
                    Text(transaction.createdOn, format: .dateTime.month().day())
                    Text("@")
                    Text(transaction.createdOn, format: .dateTime.hour().minute().second())
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        path.append(NavData(navView: .transactionEditor, transaction: transaction))
                    } label: {
                        Label("Edit transaction", systemImage: "pencil")
                    }
                    
                    Divider()
                    
                    Button {} label: {
                        Label("Attach file", systemImage: "doc")
                    }
                    Button {} label: {
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
        .navigationTitle("Transaction Details")
    }
    
    func addNewDocument() {}

    func addNewPhoto() {}
}

#Preview {
    do {
        let previewer = try Previewer()
        
        previewer.cvsTransaction.files?.append(AccountTransactionFile(name: "Receipt", filename: "receipt.jpg", isTaxRelated: true, transaction: previewer.cvsTransaction))
        
        previewer.cvsTransaction.files?.append(AccountTransactionFile(name: "Coupon", filename: "coupon.jpg", transaction: previewer.cvsTransaction))
        
        previewer.cvsTransaction.tags?.append(Tag(name: "TEST"))
        
        return TransactionDetailView(path: .constant(NavigationPath()), transaction: previewer.cvsTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
