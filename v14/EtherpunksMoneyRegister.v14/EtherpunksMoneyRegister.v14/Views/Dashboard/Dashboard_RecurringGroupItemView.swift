//
//  Dashboard_RecurringViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_RecurringGroupView: View {
    var recurringGroup: RecurringGroup
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            VStack {
                Text("Group: \(recurringGroup.name)")
                    .foregroundStyle(isSelected ? Color.black : Color.white)
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
                Divider()

                if recurringGroup.recurringTransactions != nil {
                    ForEach(
                        recurringGroup.recurringTransactions!.sorted(by: { ($0.nextDueDate!, $0.name) < ($1.nextDueDate!, $1.name) })
                    ) { recurringTransaction in
                        HStack {
                            Text("\t - \(recurringTransaction.name) [\(recurringTransaction.nextDueDate?.toSummaryDateMMMDD() ?? "")]")
                                .foregroundStyle(isSelected ? Color.black : Color.white)

                            Spacer()
                        }
                        //.frame(alignment: .trailing)
                    }
                } else {
                    Text("Nil")
                }
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
    Dashboard_RecurringGroupView(recurringGroup: Previewer().billGroup, isSelected: false, action: {})
}

#Preview("Selected") {
    Dashboard_RecurringGroupView(recurringGroup: Previewer().billGroup, isSelected: true, action: {})
}
