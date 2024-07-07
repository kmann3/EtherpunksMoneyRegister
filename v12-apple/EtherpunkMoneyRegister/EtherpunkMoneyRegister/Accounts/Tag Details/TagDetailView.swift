//
//  TagDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/31/24.
//

import SwiftUI

struct TagDetailView: View {
    @Binding var path: NavigationPath
    @Bindable var tag: TransactionTag

    var body: some View {
        VStack {
            Text("Tag Details")
            Text("\(tag.name)")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return TagDetailView(path: .constant(NavigationPath()), tag: previewer.billsTag)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
