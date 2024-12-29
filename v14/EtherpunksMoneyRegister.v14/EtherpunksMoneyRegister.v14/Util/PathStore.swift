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

    public func goTo(path: NavView) {
        self.path.append(path)
    }
}
