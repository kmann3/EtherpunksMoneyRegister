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
            Grid(horizontalSpacing: 0, verticalSpacing: 2) {
                GridRow {
                    Text("Name")
                    Text("RT#")
                    Text("Amount")
                }
                .font(.headline)
                Divider()

                ForEach(self.viewModel.recurringGroups, id: \.id) { group in
                    GridRow {
                        ZStack {
                            self.viewModel.selectedGroup?.id == group.id ? Color.blue.opacity(0.3) : Color.clear
                            Text(group.name)
                        }

                        ZStack {
                            self.viewModel.selectedGroup?.id == group.id ? Color.blue.opacity(0.3) : Color.clear
                            Text("\(group.recurringTransactions?.count ?? 0)")
                        }

                        ZStack {
                            self.viewModel.selectedGroup?.id == group.id ? Color.blue.opacity(0.3) : Color.clear
                            Text("\((group.recurringTransactions?.reduce(Decimal(0)) { $0 + $1.amount } ?? Decimal(0)).toDisplayString())")
                        }
                    }
                    .padding(.vertical, 3)
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
    RecurringGroupListView(selectedGroup: MoneyDataSource.shared.previewer.billGroup) { action in debugPrint(action) }
}

#Preview {
    RecurringGroupListView() { action in debugPrint(action) }
}
