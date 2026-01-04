//
//  PathStore.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/29/24.
//
//  Orig: https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-navigationstack-paths-using-codable

import Foundation
import SwiftUI

/*
 NavigationPath persistence is currently unused because the app uses NavigationSplitView
 with an explicit NavigationState. The persistence code is being disabled to avoid confusion.
*/

@Observable
class PathStore {
    /*
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    */

    var selectedTab: MenuOptionsEnum = .dashboard

    enum Route: Hashable {
        case account_Create
        case account_Details(account: Account)
        case account_Edit(account: Account)
        case account_List

        case dashboard

        case recurringGroup_Create
        case recurringGroup_Details(recGroup: RecurringGroup)
        case recurringGroup_Edit(recGroup: RecurringGroup)
        case recurringGroup_List(recGroup: RecurringGroup?)
        case recurringGroup_Reserve(recGroup: RecurringGroup)

        case recurringTransaction_Create
        case recurringTransaction_Create_FromTran(tran: AccountTransaction)
        case recurringTransaction_Details(recTran: RecurringTransaction)
        case recurringTransaction_Edit(recTran: RecurringTransaction)
        case recurringTransaction_List(recTran: RecurringTransaction?)
        case recurringTransaction_Reserve(recTran: RecurringTransaction)

        case report_Tax

        case search

        case settings

        case tag_Create
        case tag_Details(tag: TransactionTag)
        case tag_Edit(tag: TransactionTag)
        case tag_List(tag: TransactionTag?)

        case transaction_Create
        case transaction_Detail(transaction: AccountTransaction)
        case transaction_Edit(transaction: AccountTransaction)
        case transaction_List(account: Account)
    }

    func getVariable(route: Route) -> Any? {
        switch route {
        case .account_Details(let account):
            return account

        default:
            return nil
        }
    }

    /*
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(
                NavigationPath.CodableRepresentation.self, from: data)
            {
                path = NavigationPath(decoded)
                return
            }
        }

        // No previous path; Start new
        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }

    /// Go backwards once
    public func backUpPath() {
        path.removeLast(1)
    }

    /// Go to the beginning - home / dashboard
    public func clearPathAndGoHome() {
        path.removeLast(path.count)
    }

    // https://tanaschita.com/swiftui-navigationpath/
    public func navigateTo(route: Route) {
        path.append(route)
    }
    */
}
