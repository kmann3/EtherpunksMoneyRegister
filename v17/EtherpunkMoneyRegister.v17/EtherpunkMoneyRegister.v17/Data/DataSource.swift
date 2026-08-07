//
//  DataSource.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 8/7/26.
//

import Foundation
import Foundation
import SwiftData
import SwiftUI

@MainActor
final class DataSource: Sendable {
    public let modelContainer: ModelContainer
    public let modelContext: ModelContext
    
    static let shared = DataSource()
    
    public static let shema = Schema([
        Account.self,
        AccountTransaction.self,
        RecurringGroup.self,
        RecurringTransaction.self,
        Sync.self,
        TransactionFile.self,
        TransactionTag.self
    ])
    
#if DEBUG
    public let previewer: Previewer
#endif
    
    init() {
        self.modelContainer = {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: MoneyDataSource.shema, configurations: [config])
            } catch {
                fatalError("fatal error: Could not create ModelContainer: \(error)")
            }
        }()

        self.modelContext = modelContainer.mainContext
        #if DEBUG
        DLog("-----------------")
        DLog(Date().toDebugDate())
        DLog("-----------------")
        DLog("Database Location: \(modelContext.sqliteLocation)")
        DLog("-----------------")

        do {
            try modelContext.delete(model: Account.self)
            try modelContext.delete(model: AccountTransaction.self)
            try modelContext.delete(model: RecurringGroup.self)
            try modelContext.delete(model: RecurringTransaction.self)
            try modelContext.delete(model: TransactionFile.self)
            try modelContext.delete(model: TransactionTag.self)
            try modelContext.delete(model: UserPrefs.self)
        } catch {
            DLog("Failed to clear database. Err: \(error)")
        }

        self.previewer = Previewer()
        previewer.commitToDb(modelContext)
#endif
    }
    
}
