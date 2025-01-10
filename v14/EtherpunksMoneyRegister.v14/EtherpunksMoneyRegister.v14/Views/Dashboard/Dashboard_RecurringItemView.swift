//
//  Dashboard_RecurringViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_RecurringItemView: View {
    var recurringItem: RecurringTransaction
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(recurringItem.name)
                    .frame(maxWidth: 200, alignment: .leading)
                    .foregroundStyle(isSelected ? Color.black : Color.blue)
                Spacer()
                Text(recurringItem.nextDueDate?.toSummaryDate() ?? "")
                    .frame(maxWidth: 200, alignment: .center)
                    .foregroundStyle(isSelected ? Color.black : Color.blue)
                Spacer()
                Text("$\(Currency(amount: recurringItem.amount).amount)")
                    .frame(maxWidth: 150, alignment: .trailing)
                    .foregroundStyle(isSelected ? Color.black : Color.blue)
            }
        }
        #if os(macOS)
        .background(isSelected ? Color.blue : Color.black)
        #endif
        #if os(iOS)
        .background(isSelected ? (Color.teal).opacity(0.2) : Color.clear)
        #endif
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 1)
#endif
    }
}

#Preview("Unselected") {
    Dashboard_RecurringItemView(recurringItem: Previewer().discordRecurringTransaction, isSelected: false, action: {})
}

#Preview("Selected") {
    Dashboard_RecurringItemView(recurringItem: Previewer().discordRecurringTransaction, isSelected: true, action: {})
}
