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
    @State private var accountStartingBalance: String

    private var isNewAccount: Bool = false

    init(account: Account, path: Binding<NavigationPath>) {
        self._path = path
        self.account = account
        _accountName = State(initialValue: account.name)
        _accountStartingBalance = State(initialValue: "\(account.startingBalance)")

        if account.name == "" {
            isNewAccount = true
        }
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

                HStack {
                    Text("Transaction Count: \(account.transactionCount)")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(isNewAccount ? "New Account" : "Edit \(account.name)")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        saveAccount()
                    }
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func saveAccount() {
        guard let startingBalance = Decimal(string: accountStartingBalance) else { return }

        if startingBalance != account.startingBalance {
            let difference: Decimal = account.startingBalance - startingBalance
            print(difference)
            account.currentBalance = account.currentBalance + difference
            account.startingBalance = startingBalance


            account.rebalance(amount: difference, modelContext: modelContext)
        }

        account.name = accountName
        do {
            if isNewAccount {
                modelContext.insert(account)
            }
            try modelContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving transaction: \(error)")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return EditAccountDetailsView(account: previewer.cuAccount, path: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
