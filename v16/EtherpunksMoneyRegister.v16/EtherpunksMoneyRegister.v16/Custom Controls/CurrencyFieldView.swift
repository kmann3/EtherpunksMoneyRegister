//
//  CurrencyFieldView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kennith Mann on 6/14/25.
//

import SwiftUI

struct CurrencyFieldView: View {
    @Binding var amount: Decimal
    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    // Use your existing helper if you have one; otherwise configure here.
    private var currencyFormatter: NumberFormatter {
        let nf = NumberFormatter.localCurrencyFormatter
        // Ensure these are sane for your currency
        nf.minimumFractionDigits = nf.maximumFractionDigits // keep consistent
        return nf
    }

    private var decimalSeparator: String {
        currencyFormatter.decimalSeparator ?? "."
    }

    private var maxFractionDigits: Int {
        currencyFormatter.maximumFractionDigits
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(currencyFormatter.currencySymbol ?? "$")
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            TextField("Amount", text: $text)
                .focused($isFocused)
                .multilineTextAlignment(.leading)
                .monospacedDigit()
#if os(iOS)
                .keyboardType(.decimalPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { isFocused = false }
                    }
                }
#endif
                .onAppear {
                    // Show display-formatted value initially
                    text = formatForDisplay(amount)
                }
                .onChange(of: isFocused) {
                    if isFocused {
                        // Switch to a plain, editing-friendly representation
                        text = formatForEditing(amount)
                    } else {
                        // Commit and show display formatting
                        text = formatForDisplay(amount)
                    }
                }
                .onChange(of: text) {
                    // Sanitize input according to locale rules
                    let sanitized = sanitize(text)
                    if sanitized != text {
                        // Only assign if actually changed to avoid cursor jitter
                        text = sanitized
                    }

                    // Convert to a normalized string with '.' as decimal separator for Decimal parsing
                    let normalized = normalizedForDecimalParsing(sanitized)

                    if let decimal = Decimal(string: normalized) {
                        amount = decimal
                    } else {
                        // If the field is empty or only a '-', keep amount at 0 (or your preferred behavior)
                        if sanitized.isEmpty || sanitized == "-" {
                            amount = 0
                        }
                    }
                }
                .padding(5)
        }
    }

    // MARK: - Formatting and sanitization

    // Display formatting: full currency, grouping separators, etc.
    private func formatForDisplay(_ decimal: Decimal) -> String {
        currencyFormatter.string(from: decimal as NSNumber) ?? ""
    }

    // Editing formatting: no currency symbol, no grouping, locale decimal separator, limited fraction digits
    private func formatForEditing(_ decimal: Decimal) -> String {
        // Build a simple editing string using the locale’s decimal separator
        // Avoid grouping for a cleaner editing experience
        let components = NSDecimalNumber(decimal: decimal).stringValue.split(separator: ".")
        let intPart = String(components.first ?? "0")
        let fracPart = components.count > 1 ? String(components[1]) : nil

        if let fracPart, maxFractionDigits > 0 {
            let trimmed = String(fracPart.prefix(maxFractionDigits))
            return trimmed.isEmpty ? intPart : intPart + decimalSeparator + trimmed
        } else {
            return intPart
        }
    }

    private func sanitize(_ input: String) -> String {
        // Allow digits, one leading '-', and one decimal separator (locale-aware).
        // Limit fraction digits to maxFractionDigits.
        var result = ""
        var hasSeparator = false
        var hasMinus = false
        var fractionCount = 0

        for (idx, ch) in input.enumerated() {
            if ch.isNumber {
                if hasSeparator {
                    if fractionCount < maxFractionDigits {
                        result.append(ch)
                        fractionCount += 1
                    }
                } else {
                    result.append(ch)
                }
            } else if String(ch) == decimalSeparator {
                if !hasSeparator && maxFractionDigits > 0 {
                    hasSeparator = true
                    result.append(ch)
                }
            } else if ch == "-" {
                // Only allow minus at the very beginning
                if idx == 0 && !hasMinus {
                    hasMinus = true
                    result.insert("-", at: result.startIndex)
                }
            } else {
                continue
            }
        }

        // If we ended up with just "-", keep it (user may be starting to type a negative)
        return result
    }

    private func normalizedForDecimalParsing(_ input: String) -> String {
        // Replace locale decimal separator with '.' for Decimal(string:)
        if decimalSeparator != "." {
            return input.replacingOccurrences(of: decimalSeparator, with: ".")
        }
        return input
    }
}

#Preview {
    @Previewable @State var foo: Decimal = 123456.45
    CurrencyFieldView(amount: $foo)
}
