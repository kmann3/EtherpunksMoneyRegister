//
//  Dashboard_RecurringViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_RecurringItemView: View {
    var recurringItem: RecurringTransaction
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(recurringItem.name)
                    .frame(maxWidth: 200, alignment: .leading)
                    .foregroundStyle(Color.primary)
                Spacer()
                Text(recurringItem.nextDueDate?.toSummaryDateMMMDEEE() ?? "")
                    .frame(maxWidth: 200, alignment: .center)
                    .foregroundStyle(Color.primary)
                Spacer()
                Text(
                    recurringItem.amount.toDisplayString()
                )
                .frame(maxWidth: 150, alignment: .trailing)
                .foregroundStyle(Color.primary)
            }
        }
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 1)
#endif
    }
}

#Preview("Unselected") {
    Dashboard_RecurringItemView(recurringItem: Previewer().discordRecurringTransaction, action: {})
}

#Preview("Selected") {
    Dashboard_RecurringItemView(recurringItem: Previewer().discordRecurringTransaction, action: {})
}
