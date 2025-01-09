//
//  Dashboard_RecurringViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_RecurringViewItem: View {
    var recurringItem: RecurringTransaction
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(recurringItem.name)
                    .frame(maxWidth: 200, alignment: .leading)
                Spacer()
                Text(recurringItem.nextDueDate?.toSummaryDate() ?? "")
                    .frame(maxWidth: 200, alignment: .center)
                Spacer()
                Text("$\(Currency(amount: recurringItem.amount).amount)")
                    .frame(maxWidth: 150, alignment: .trailing)
            }
        }
        .background(isSelected ? Color.blue : Color.clear)
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 1)
#endif
    }
}

#Preview {
    let p = Previewer()
    Dashboard_RecurringViewItem(recurringItem: p.discordRecurringTransaction, isSelected: false, action: {})
        .modelContainer(p.container)
}
