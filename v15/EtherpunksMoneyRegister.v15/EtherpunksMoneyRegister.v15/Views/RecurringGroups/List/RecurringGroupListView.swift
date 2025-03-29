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
            ForEach(self.viewModel.recurringGroups, id: \.id) { group in
                VStack {
                    HStack {
                        Text(group.name)
                        Spacer()
                    }

                    HStack {
                        Text("\tRecurring Transactions #:\t\(group.recurringTransactions?.count ?? 0)")
                        Spacer()
                    }
                }
                .background(self.viewModel.selectedGroup?.id == group.id ? Color.blue.opacity(0.3) : Color.clear)

                .onTapGesture { t in
                    handler(PathStore.Route.recurringGroup_Details(recGroup: group))
                }
            }
        }
        .frame(minWidth: 300)
    }
}

#Preview {
    RecurringGroupListView() { action in }
}
