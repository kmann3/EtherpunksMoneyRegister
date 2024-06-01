//
//  TransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import SwiftUI
import QuickLook

struct TransactionDetailView: View {
    @Binding var path: NavigationPath
    @Bindable var transaction: AccountTransaction
    
    @State var url: URL?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(transaction.name)")
            Text("Type: \(transaction.transactionType)")
            HStack {
                Text("Amount: ")
                Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            if(transaction.tags != nil) {
                HStack {
                    Text("Tags: ")
                    ForEach(transaction.tags!) { tag in
                        NavigationLink(value: NavData(navView: .tagDetail, tag: tag)) {
                            Text(tag.name)
                        }
                    }
                    
                }
            }
            HStack {
                Text("Created: ")
                Text(transaction.createdOn, format: .dateTime.month().day())
                Text("@")
                Text(transaction.createdOn, format: .dateTime.hour().minute().second())

            }
            if(transaction.pending != nil) {
                HStack {
                    Text("Pending: ")
                    Text(transaction.pending!, format: .dateTime.month().day())
                    Text("@")
                    Text(transaction.pending!, format: .dateTime.hour().minute().second())
                }.background(transaction.backgroundColor)
            } else {
                Text("Pending: <none>").background(transaction.backgroundColor)
            }
            
            if(transaction.cleared != nil) {
                HStack {
                    Text("Cleared: ")
                    Text(transaction.cleared!, format: .dateTime.month().day())
                    Text("@")
                    Text(transaction.cleared!, format: .dateTime.hour().minute().second())
                }.background(transaction.backgroundColor)
            } else {
                Text("Cleared: <none>").background(transaction.backgroundColor)
            }
            
            if(transaction.recurringTransaction != nil) {
                HStack {
                    Text("Recurring Transaction: ")
                    NavigationLink(value: NavData(navView: .recurringTransactionDetail, recurringTransaction: transaction.recurringTransaction!)) {
                        Text(transaction.recurringTransaction!.name)
                    }
                }
            }
            
            if(transaction.recurringTransaction != nil && transaction.recurringTransaction?.group != nil) {
                HStack {
                    Text("Recurring Transaction Group: ")
                    NavigationLink(value: NavData(navView: .recurringTransactionGroupDetail, recurringTransactionGroup: transaction.recurringTransaction!.group)) {
                        Text(transaction.recurringTransaction!.group!.name)
                    }
                }
            }
            
            Text("Attachments: \(transaction.fileCount)")
            List {
                if(transaction.fileCount > 0) {
                    ForEach(transaction.files!) { file in
                        VStack(alignment: .leading) {
                            if(file.name != file.filename) {
                                HStack {
                                    Text("Name: \(file.name)")
                                }
                            }
                            HStack {
                                Button("Filename: \(file.filename)") {
                                    url = file.url
                                }.quickLookPreview($url)
                            }
                            HStack{
                                Text("Created On: ")
                                Text(file.createdOn, format: .dateTime.month().day())
                                Text("@")
                                Text(file.createdOn, format: .dateTime.hour().minute().second())
                            }
                            HStack {
                                Text("Tax Document: \(file.isTaxRelated)")
                            }
                            HStack {
                                Text("Notes: \(file.notes)")
                            }
                        }
                    }
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
                    
                    Button {
                        
                    } label: {
                        Label("Attach file", systemImage: "doc")
                    }
                    Button {
                        
                    } label: {
                        Label("Attach photo", systemImage: "photo")
                    }
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        Label("Create Recurring Transaction", systemImage: "repeat")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .navigationTitle("Transaction Details")
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return TransactionDetailView(path: .constant(NavigationPath()), transaction: previewer.cvsTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
