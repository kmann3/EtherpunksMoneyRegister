//
//  TagItemView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/25/24.
//

import SwiftData
import SwiftUI

struct TransactionTagItemView: View {
    @Environment(\.modelContext) var modelContext
    @State var accountTransactions: [AccountTransaction]? = nil
    @State var useCount: Int = 0
    @State var lastUsed: Date? = nil
    var transactionTag: TransactionTag

    init(transactionTag: TransactionTag) {
        self.transactionTag = transactionTag
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.transactionTag.name)
                    .frame(width: 100, height: 30)

                Spacer()

                Text("Last Used:")
                if lastUsed != nil {
                    Text(lastUsed!, format: .dateTime.month().day().year())
                    //.frame(width: 100, height: 30)
                } else {
                    Text("Never")
                    //.frame(width: 100, height: 30)
                }

                Spacer()
                Text("#: \(useCount)")
                //.frame(width: 100, height: 30)
            }
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        let tagId = transactionTag.id

        var fetchDescriptor: FetchDescriptor<TransactionTag> {
            var descriptor = FetchDescriptor<TransactionTag>(
                predicate: #Predicate<TransactionTag> {
                    $0.id == tagId
                }
            )
            descriptor.fetchLimit = 1
            descriptor.relationshipKeyPathsForPrefetching = [
                \.accountTransactions
            ]
            return descriptor
        }

        let query = try! modelContext.fetch(fetchDescriptor)

        if query.count > 0 {
            accountTransactions = query.first!.accountTransactions
            useCount = accountTransactions?.count ?? 0
            lastUsed = accountTransactions?.first?.createdOnUTC ?? nil

        } else {
            accountTransactions = nil
            useCount = 0
        }
    }
}

#Preview {
    let p = Previewer()
    TransactionTagItemView(transactionTag: p.ffTag)
        .modelContainer(p.container)
}
