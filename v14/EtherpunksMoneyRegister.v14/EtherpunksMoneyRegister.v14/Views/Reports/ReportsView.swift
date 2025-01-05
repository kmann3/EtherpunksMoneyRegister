//
//  ReportsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct ReportsView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Text("ReportsView")
        // Notes: A report that shows a calendar with the transaction count per day
        // Notes: That same report could also filter - e.g. remove recurring transactions
        // Notes: Same report: Filter by tag? 
    }
}

#Preview {
    ReportsView()
}
