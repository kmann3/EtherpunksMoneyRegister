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
            Text("Tag info: \(self.viewModel.tag.name)")
        }
        .frame(width: 450)
    }


}

#Preview {
    TagDetailView(tag: MoneyDataSource.shared.previewer.billsTag, { _ in })
}
