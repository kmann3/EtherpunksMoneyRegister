//
//  TagItemView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/25/24.
//

import SwiftUI

struct TransactionTagItemView: View {
    var transactionTag: TransactionTag
    var useCount: Int = Int.random(in: 1..<23495)
    var lastUsed: Date? = Date()

    init(transactionTag: TransactionTag) {
        self.transactionTag = transactionTag

        // TODO: Calculate use count

        // TODO: Calculate last used date
        let empty: Int = Int.random(in: 1..<4)
        debugPrint(empty)
        if(empty == 2) {
            lastUsed = nil
        }
    }

    var body: some View {
        VStack  (alignment: .leading){
            HStack {
                Text(transactionTag.name)
                    .frame(width: 100, height: 30)

                Spacer()

                Text("Last Used:")
                if(lastUsed != nil) {
                    Text(lastUsed!, format: .dateTime.month().day().year())
                        .frame(width: 100, height: 30)
                } else {
                    Text("Never")
                        .frame(width: 100, height: 30)
                }

                Spacer()
                Text("#: \(useCount)")
                    .frame(width: 100, height: 30)
            }
        }
    }
}

#Preview {
    let p = Previewer()
    TransactionTagItemView(transactionTag: p.billsTag)
}
