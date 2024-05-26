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
    @Bindable var account: Account
    
    private var title: String {
        account.name == "" ? "Add Account" : "Edit \(account.name)"
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
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button ("Save") {
                    // Save
                    withAnimation {
                        save()
                        dismiss()
                    }
//                    Button ("Save") {
                    // Save
                    account.currentBalance = account.startingBalance
                    account.lastBalanced = Date()
                    path.removeLast()
                }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button ("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
        }
    }
    
    private func save() {
        
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return EditAccountView(path: .constant(NavigationPath()), account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
