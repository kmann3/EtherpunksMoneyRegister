//
//  PathStore.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/29/24.
//
//  Orig: https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-navigationstack-paths-using-codable

import Foundation
import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    var selectedTab: MenuOptionsEnum = .dashboard

    enum Route: Hashable {
        case account_Create
        case account_Details
        case account_Edit
        case account_List

        case dashboard

        case recurringGroup_Create
        case recurringGroup_Details
        case recurringGroup_Edit
        case recurringGroup_List

        case recurringTransaction_Create
        case recurringTransaction_Details
        case recurringTransaction_Edit
        case recurringTransaction_List

        case report_Tax

        case tag_Create
        case tag_Edit(tag: TransactionTag)
        case tag_List

        case transaction_Create
        case transaction_Detail
        case transaction_Edit
        case transaction_List
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
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
        self.path.removeLast(1)
    }

    /// Go to the beginning - home / dashboard
    public func clearPathAndGoHome() {
        self.path.removeLast(path.count)
    }

    // https://tanaschita.com/swiftui-navigationpath/
    public func navigateTo(route: Route) {
        self.path.append(route)
    }
}
