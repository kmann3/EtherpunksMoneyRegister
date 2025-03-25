//
//  TagDetailView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/12/25.
//

import SwiftUI

struct TagDetailView: View {

    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(tag: TransactionTag, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tag: tag)
        self.handler = handler
    }

    var body: some View {
        List {
            VStack {
                HStack {
                    Text("Tag info: \(self.viewModel.tag.name)")
                    Spacer()
                }
                HStack {
                    if self.viewModel.lastUsed != nil {
                        Text("Last Used: ")
                        Text(
                            self.viewModel.lastUsed!,
                            format: .dateTime.year().month().day())
                    } else {
                        Text("Last Used: never")
                    }
                    Spacer()
                }

                HStack {
                    Text("Usage count: \(self.viewModel.itemCount)")
                    Spacer()
                }
            }
            Section(header: Text("Recurring"), footer: Text("End of list")) {
                ForEach(self.viewModel.recurringTransactions, id: \.id) { rtran in
                    VStack {
                        HStack {
                            Text("\(rtran.name)")
                            Spacer()
                            Text("\(rtran.defaultAccount?.name ?? "")")
                            Spacer()
                            if rtran.nextDueDate != nil {
                                Text(
                                    rtran.nextDueDate!,
                                    format: .dateTime.year().month().day())
                                Spacer()
                            } else {
                                Spacer()
                            }
                            Text(
                                rtran.amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier ?? "USD"))

                        }
                    }
                    .onTapGesture { action in
                        handler(PathStore.Route.recurringTransaction_Details(recTrans: rtran))
                    }
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(self.viewModel.transactions, id: \.id) { tran in
                    VStack {
                        HStack {
                            Text("\(tran.name)")
                            Spacer()
                            Text("\(tran.account!.name)")
                            Spacer()
                            Text(
                                tran.createdOnUTC,
                                format: .dateTime.year().month().day())
                            Spacer()
                            Text(
                                tran.amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier ?? "USD"))

                        }
                    }
                    .onTapGesture { t in
                        handler(PathStore.Route.transaction_Detail(transaction: tran))
                    }
                }
            }
        }
        .frame(width: 450)
    }


}

#Preview {
    TagDetailView(tag: MoneyDataSource.shared.previewer.billsTag, { _ in })
}
