//
//  TagItemView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import SwiftUI

struct TagItemView: View {
    @State var accountTransactions: [AccountTransaction]? = nil
    @State var useCount: Int = 0
    @State var lastUsed: Date? = nil
    var transactionTag: TransactionTag

    init(transactionTag: TransactionTag) {
        self.transactionTag = transactionTag
        let tagData = MoneyDataSource.shared.fetchTagItemData(self.transactionTag)
        self.useCount = tagData.count
        self.lastUsed = tagData.lastUsed
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
    }
}

#Preview {
    TagItemView(transactionTag: Previewer().billsTag)
}
