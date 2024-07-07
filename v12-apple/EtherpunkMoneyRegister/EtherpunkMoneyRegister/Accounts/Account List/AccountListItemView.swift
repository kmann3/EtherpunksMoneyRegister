//
//  AccountListItemView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/19/24.
//

import SwiftUI

struct AccountListItemView: View {
    var account: Account
    
    var body: some View {
        VStack {
            HStack {
                Text(account.name)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .padding(
                        EdgeInsets(
                            .init(top: 2, leading: 0, bottom: 5, trailing: 0)
                        )
                    )
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Available")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                
                Spacer()
                
                Text(account.currentBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }
            
            HStack {
                Text("Oustanding Amount")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                
                Spacer()
                
                Text(account.outstandingBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }
            
            HStack {
                Text("Oustanding Count")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                
                Spacer()
                
                Text("\(account.outstandingItemCount) Items")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            HStack {
                Text("Last Balanced:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                
                Spacer()
                // Text(clearedText, format: .dateTime.month().day())
                Text(account.lastBalanced, format: .dateTime.month().day().year())
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 125/255, green: 125/255, blue: 125/255, opacity: 0.5), lineWidth: 1)
        )
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return AccountListItemView(account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
