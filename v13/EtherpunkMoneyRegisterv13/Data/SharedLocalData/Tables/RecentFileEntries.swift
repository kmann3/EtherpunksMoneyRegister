//
//  RecentFileEntry.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation
import SQLite

final class RecentFileEntry: CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var path: String = ""
    public var createdOnLocal: Date {
        get {
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let utcDate = utcDateFormatter.date(from: _createdOnUTC) {
                // Convert UTC Date to local time Date
                let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                return Date(timeIntervalSinceReferenceDate: localTimeInterval)
            } else {
                debugPrint("Failed to convert UTC string to Date object.")
                return Date()
            }
        }
        set {
            // Convert local time to UTC
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            _createdOnUTC = utcDateFormatter.string(from: newValue)
        }
    }

    public var createdOnLocalString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            formatter.timeZone = .current
            return createdOnLocal.formatted()
        }
    }

    public var debugDescription: String {
            return """
            RecentFileEntry:
            - id: \(id)
            - path: \(path)
            - _createdOnUTC: \(_createdOnUTC)
            - createdOnLocal: \(createdOnLocal)
            """
    }

    private var _createdOnUTC: String = ""

    public static let recentFileEntrySqlTable = Table("RecentFileEntry")
    public static let idColumn = Expression<String>("Id")
    public static let pathColumn = Expression<String>("Path")
    public static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID, path: String, createdOnLocal: Date = Date()) {
        self.id = id
        self.path = path
        self.createdOnLocal = createdOnLocal
    }

    init(id: UUID, path: String, createdOnUTC: String) {
        self.id = id
        self.path = path
        self._createdOnUTC = createdOnUTC
    }

    init(path: String) {
        self.path = path
        self.createdOnLocal = Date()
    }

    init() {}

    public static func createTable(appDbPath: String) {
        do {
            let db = try Connection(appDbPath)

            try db.run(recentFileEntrySqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(pathColumn, unique: true)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }

    public static func deleteFileEntry(appDbPath: String, id: UUID) {
        do {
            let db = try Connection(appDbPath)

            let entry = recentFileEntrySqlTable.filter(idColumn == id.uuidString)
            try db.run(entry.delete())
        } catch {
            debugPrint(error)
        }
    }

    public static func getFileEntries(appDbPath: String) -> [RecentFileEntry] {
        do {
            let db = try Connection(appDbPath)

            var returnArray: [RecentFileEntry] = []

            let query = recentFileEntrySqlTable.order(createdOnUTCColumn.desc)

            for entry in try db.prepare(query) {
                let id_val: UUID = UUID(uuidString: entry[idColumn])!
                let path_val: String = entry[pathColumn]
                let createdOn_val: String = entry[createdOnUTCColumn]
                let newEntry = RecentFileEntry(id: id_val, path: path_val, createdOnUTC: createdOn_val)
                returnArray.append(newEntry)
                debugPrint(newEntry)
            }

            return returnArray
        } catch {
            debugPrint(error)
            return []
        }
    }

    public static func insertFilePath(appContainer: LocalAppStateContainer) {
        if(appContainer.appDbPath == nil || appContainer.loadedSqliteDbPath == nil) {
            debugPrint("path error: app:\(appContainer.appDbPath ?? "") | db:\(appContainer.loadedSqliteDbPath ?? "") ")
            return
        }

        // Get a list of the entries and make sure we aren't duplicating anything

        for entry in getFileEntries(appDbPath: appContainer.appDbPath!) {
            if entry.path == appContainer.loadedSqliteDbPath {
                // Duplicate found, no need to make another one
                debugPrint("Duplicate recent entry. Skipping this task.")
                return
            }
        }

        do {
            let db = try Connection(appContainer.appDbPath!)

            let id_val: String = UUID().uuidString
            let path_val: String = appContainer.loadedSqliteDbPath!

            let utcDateFormatter = DateFormatter()
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let createdOnUtc_val: String = utcDateFormatter.string(from: Date())

            let insert = recentFileEntrySqlTable.insert(idColumn <- id_val, pathColumn <- path_val, createdOnUTCColumn <- createdOnUtc_val)
            try db.run(insert)
        } catch {
            print (error)
        }
    }
}
