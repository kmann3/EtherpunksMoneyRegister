//
//  CurrencyFieldView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 6/14/25.
//

import SwiftUI

struct CurrencyFieldView: View {
    @Binding var amount: Decimal
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    var onCommit: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(NumberFormatter.localCurrencyFormatter.currencySymbol ?? "$")
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            TextField("Amount", text: $text, onCommit: { onCommit?() })
                .focused($isFocused)
#if os(iOS)
                .keyboardType(.decimalPad)
#endif
                .onAppear {
                    debugPrint(formatDecimal(amount))
                    text = formatDecimal(amount)
                }
                .onChange(of: text) {
                    // Use self.text directly inside
                    let filtered = filterInput(text)
                    if filtered != text {
                        text = filtered
                    }

                    if let decimal = Decimal(string: filtered) {
                        amount = decimal
                    }
                }
                .onChange(of: isFocused) {
                    if !isFocused {
                        text = formatDecimal(amount)
                        onCommit?()
                    }
                }
                .padding(5)
            
        }
    }

    private func filterInput(_ input: String) -> String {
        let allowed = "0123456789.,"
        let filtered = input.filter { allowed.contains($0) }

        // Only one decimal point
        let parts = filtered.split(separator: ".")
        if parts.count > 1 {
            return parts.prefix(2).joined(separator: ".")
        }
        return filtered
    }

    private func formatDecimal(_ decimal: Decimal) -> String {
        NumberFormatter.localCurrencyFormatter.string(from: decimal as NSNumber) ?? ""
    }
}

#Preview {
    @Previewable @State var foo: Decimal = 123456.45
    CurrencyFieldView(amount: $foo)
}
