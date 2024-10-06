//
//  IncomeSetup.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/5/24.
//

import SwiftUI

struct RecurringExpensesSetup: View {
#if DEBUG || DEBUG_IN_SIMULATOR
    @Environment(\.colorScheme) var colorScheme
#endif

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("New expense entry here")
                Spacer()
                Text("List here")
                Spacer()
            }
            Spacer()
        }
#if DEBUG || DEBUG_IN_SIMULATOR
        .background(
            colorScheme == .dark ? Color.darkGray : Color.lightGray
        )
#endif
    }
}

#Preview {
    RecurringExpensesSetup()
}
