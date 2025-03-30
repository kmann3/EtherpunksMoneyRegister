//
//  RecurringGroupListView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import SwiftUI

struct RecurringGroupListView: View {
    var viewModel = ViewModel()
    var handler: (PathStore.Route) -> Void

    init(selectedGroup: RecurringGroup? = nil, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(selectedGroup: selectedGroup)
        self.handler = handler
    }

    var body: some View {
        List {
            HStack {
                Text("Recurring Groups")
                    .bold(true)
                    .font(.title)
                Spacer()
                Button {
                    handler(PathStore.Route.recurringGroup_Create)
                } label: {
                    Text("+")
                }
            }
            Grid {
                GridRow {
                    Text("Name")
                    Text("RT#")
                    Text("Amount")
                }
                .font(.headline)
                Divider()

                ForEach(self.viewModel.recurringGroups, id: \.id) { group in
                    GridRow {
                        Text(group.name)
                        Text("\(group.recurringTransactions?.count ?? 0)")
                        Text("\((group.recurringTransactions?.reduce(Decimal(0)) { $0 + $1.amount } ?? Decimal(0)).toDisplayString())")
                    }
                    .padding(.vertical, 3)
                    .background(self.viewModel.selectedGroup?.id == group.id ? Color.blue.opacity(0.3) : Color.clear)
                    .onTapGesture {
                        handler(PathStore.Route.recurringGroup_Details(recGroup: group))
                    }
                }
            }
        }
        .frame(minWidth: 300)
    }
}

#Preview {
    RecurringGroupListView() { action in debugPrint(action) }
}
