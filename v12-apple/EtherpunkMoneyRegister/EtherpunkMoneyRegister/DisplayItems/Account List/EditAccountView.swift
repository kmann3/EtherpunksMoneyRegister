//
//  EditAccountView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/21/24.
//

import SwiftUI

struct EditAccountView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    @Binding var doSave: Bool
    @Bindable var account: Account
    
    private var isNewAccount: Bool {
        account.name == "" ? true : false
    }
    
    private var title: String {
        isNewAccount ? "Add Account" : "Edit \(account.name)"
    }
    
    init(path: Binding<NavigationPath>, doSave: Binding<Bool>, account: Account) {
        self._path = path
        self._doSave = doSave
        self.account = account
    }
        
    var body: some View {
        Form {
            HStack {
                Text("Name:")
                TextField("Name", text: $account.name)
            }
            HStack {
                Text("Starting Balance:")
                TextField("Amount", value: $account.startingBalance, format: .number.precision((.fractionLength(2))))
                    #if os(iOS)
                    .keyboardType(.decimalPad)
                    #endif
                    
            }
            HStack {
                Text("Notes:")
                TextField("Name", text: $account.notes)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button ("Save") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
            }
        
            ToolbarItem(placement: .cancellationAction) {
                Button ("Cancel", role: .cancel) {
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
        return EditAccountView(path: .constant(NavigationPath()), doSave: .constant(doSave),  account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
