//
//  RecurringTransactionsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftData
import SwiftUI

struct RecurringTransactionsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router

    @Query(sort: [SortDescriptor(\RecurringGroup.name)])
    var recurringGroups: [RecurringGroup]

    @Query(
        filter: #Predicate<RecurringTransaction> { transaction in
            if transaction.recurringGroup == nil {
                return true
            } else {
                return false
            }
        }
        ,sort: [SortDescriptor(\.name)]
    ) var noGroupRecTran: [RecurringTransaction]

    enum itemType {
        case group
        case transaction
    }

    var body: some View {
        VStack {
            List {
                Section(header: Text("No Assigned Group")) {
                    ForEach(noGroupRecTran) { recTran in
                        Text(recTran.name)
                    }
                }

                ForEach(recurringGroups) { group in
                    Section(header: Text(group.name)) {
                        ForEach(group.recurringTransactions!) { transaction in
                            Text(transaction.name)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecurringTransactionsView()
        .modelContainer(Previewer().container)
        .environment(PathStore())
#if os(macOS)
        .frame(width: 900, height: 500)
#endif

}
