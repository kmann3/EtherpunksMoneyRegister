//
//  InternalView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 7/7/24.
//

import SwiftUI

struct RelativeView: View {
    var body: some View {
        List {
            
            VStack {
                HStack {
                    Text("Recurring Transactions")
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

                Text("Income: 2")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                Text("Expenses: 23")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                Text("Irregular: 5")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 125/255, green: 125/255, blue: 125/255, opacity: 0.5), lineWidth: 1)
            )

            VStack {
                HStack {
                    Text("Tags")
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

                Text("Total: 23")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                Text("Unused: 3")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 125/255, green: 125/255, blue: 125/255, opacity: 0.5), lineWidth: 1)
            )
        }
    }
}

#Preview {
    RelativeView()
}
