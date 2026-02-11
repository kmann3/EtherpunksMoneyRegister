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
extension PathStore.Route: CustomStringConvertible {
    var description: String {
        switch self {
        case .account_Create:
            return "account_Create"
        case .account_Details(let account):
            return "account_Details(\(account.id))"
        case .account_Edit(let account):
            return "account_Edit(\(account.id))"
        case .account_List:
            return "account_List"

        case .dashboard:
            return "dashboard"

        case .recurringGroup_Create:
            return "recurringGroup_Create"
        case .recurringGroup_Details(let recGroup):
            return "recurringGroup_Details(\(recGroup.id))"
        case .recurringGroup_Edit(let recGroup):
            return "recurringGroup_Edit(\(recGroup.id))"
        case .recurringGroup_List(let recGroup):
            if let recGroup = recGroup {
                return "recurringGroup_List(\(recGroup.id))"
            } else {
                return "recurringGroup_List(nil)"
            }
        case .recurringGroup_Reserve(let recGroup):
            return "recurringGroup_Reserve(\(recGroup.id))"

        case .recurringTransaction_Create:
            return "recurringTransaction_Create"
        case .recurringTransaction_Create_FromTran(let tran):
            return "recurringTransaction_Create_FromTran(\(tran.id))"
        case .recurringTransaction_Details(let recTran):
            return "recurringTransaction_Details(\(recTran.id))"
        case .recurringTransaction_Edit(let recTran):
            return "recurringTransaction_Edit(\(recTran.id))"
        case .recurringTransaction_List(let recTran):
            if let recTran = recTran {
                return "recurringTransaction_List(\(recTran.id))"
            } else {
                return "recurringTransaction_List(nil)"
            }
        case .recurringTransaction_Reserve(let recTran):
            return "recurringTransaction_Reserve(\(recTran.id))"

        case .report_Tax:
            return "report_Tax"

        case .search:
            return "search"

        case .settings:
            return "settings"

        case .tag_Create:
            return "tag_Create"
        case .tag_Details(let tag):
            return "tag_Details(\(tag.id))"
        case .tag_Edit(let tag):
            return "tag_Edit(\(tag.id))"
        case .tag_List(let tag):
            if let tag = tag {
                return "tag_List(\(tag.id))"
            } else {
                return "tag_List(nil)"
            }

        case .transaction_Create:
            return "transaction_Create"
        case .transaction_Detail(let transaction):
            return "transaction_Detail(\(transaction.id))"
        case .transaction_Edit(let transaction):
            return "transaction_Edit(\(transaction.id))"
        case .transaction_List(let account):
            return "transaction_List(\(account.id))"
        }
    }
}

