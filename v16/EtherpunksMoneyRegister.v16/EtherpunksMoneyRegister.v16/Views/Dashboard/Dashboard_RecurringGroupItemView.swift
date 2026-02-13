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

    var bgColor: Color = Color.clear

    init(recurringGroup: RecurringGroup, action: @escaping () -> Void) {
        self.recurringGroup = recurringGroup
        self.action = action

        if self.recurringGroup.recurringTransactions![0].transactionType == .debit {
            self.bgColor = Color.brown.opacity(0.6)
        } else {
            self.bgColor = Color.green.opacity(0.5)
        }
    }

    var body: some View {
        Button(action: action) {
            VStack {
                Text("Group: \(recurringGroup.name)")
                    .foregroundStyle(Color.primary)
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
                    .font(.title2)
                Divider()

                if recurringGroup.recurringTransactions != nil {
                    ForEach(
                        recurringGroup.recurringTransactions!.sorted(by: { ($0.nextDueDate!, $0.name) < ($1.nextDueDate!, $1.name) })
                    ) { recurringTransaction in
                        HStack {
                            Text("\t - \(recurringTransaction.name) [\(recurringTransaction.nextDueDate?.toSummaryDateMMMDD() ?? "")]")
                                .foregroundStyle(Color.primary)
                                .font(.title3)

                            Spacer()
                        }
                    }
                } else {
                    Text("Nil - ERROR")
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(self.bgColor)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        #if os(macOS)
            .padding(.all, 1)
        #endif
    }
}

#Preview("Unselected") {
    Dashboard_RecurringGroupView(recurringGroup: MoneyDataSource.shared.previewer.billGroup, action: {})
}
