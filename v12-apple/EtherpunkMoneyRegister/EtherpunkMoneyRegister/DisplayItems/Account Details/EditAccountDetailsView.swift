//
//  EditAccountView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/21/24.
//

import SwiftUI

struct EditAccountDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext

    @Binding var path: NavigationPath

    @State private var account: Account
    @State private var accountName: String

    private var title: String {
        account.name == "" ? "Add Account" : "Edit \(account.name)"
    }
    
    init(path: Binding<NavigationPath>, doSave: Binding<Bool>, account: Account) {
        self._path = path
        self.account = account
        _accountName = State(initialValue: account.name)
    }
        
    var body: some View {
        Form {
            Section(header: Text("Transaction Details")) {
                TextField("Name:", text: $account.name)
                TextField("Starting Balance:", value: $account.startingBalance, format: .number.precision(.fractionLength(2)))
                #if os(iOS)
                    .keyboardType(.decimalPad)
                #endif
                
                TextField("Notes:", text: $account.notes)
            }
            
            Section(header: Text("Misc")) {
                HStack {
                    Text("Current Balance:")
                    Text(account.currentBalance, format: .number.precision(.fractionLength(2)))
                }
                
                HStack {
                    Text("Last Balanced:")
                    Text(account.lastBalanced, format: .dateTime.month().day().year())
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(title)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                }
        
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        doSave = false
                        dismiss()
                    }
                }
            }
    }
    
    private func save() {
        doSave = true
        account.currentBalance = account.startingBalance
        account.lastBalanced = Date()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        let doSave: Bool = false
        return EditAccountDetailsView(path: .constant(NavigationPath()), doSave: .constant(doSave), account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
