//
//  Dashboard_RecurringViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_RecurringGroupView: View {
    var recurringGroup: RecurringGroup
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            VStack {
                Text("Group: \(recurringGroup.name)")
                    .foregroundStyle(Color.white)
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
                Divider()

                if recurringGroup.recurringTransactions != nil {
                    ForEach(
                        recurringGroup.recurringTransactions!.sorted(by: { ($0.nextDueDate!, $0.name) < ($1.nextDueDate!, $1.name) })
                    ) { recurringTransaction in
                        HStack {
                            Text("\t - \(recurringTransaction.name) [\(recurringTransaction.nextDueDate?.toSummaryDateMMMDD() ?? "")]")
                                .foregroundStyle(Color.white)

                            Spacer()
                        }
                    }
                } else {
                    Text("Nil - ERROR")
                }
            }
        }
        #if os(macOS)
        .background(Color.black)
        #endif
        #if os(iOS)
        .background(Color.clear)
        #endif
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 1)
#endif
    }
}

#Preview("Unselected") {
    Dashboard_RecurringGroupView(recurringGroup: Previewer().billGroup, action: {})
}
