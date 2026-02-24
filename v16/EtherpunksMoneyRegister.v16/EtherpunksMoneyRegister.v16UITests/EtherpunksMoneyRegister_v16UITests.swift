//
//  EtherpunksMoneyRegister_v16UITests.swift
//  EtherpunksMoneyRegister.v16UITests
//
//  Created by Kenny Mann on 2/11/26.
//

import XCTest

final class EtherpunksMoneyRegister_v16UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - ReserveGroupView (Monthly Bills) UI tests

    @MainActor
    func testReserveGroupSheet_AppearsForMonthlyBills() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-UITestBridge"]
        app.launch()

        openReserveGroupSheet(app, groupName: "Monthly Bills")

        // Verify the sheet header appears with the group name
        let header = app.staticTexts["Reserve Transactions: Monthly Bills"]
        XCTAssertTrue(header.waitForExistence(timeout: 5.0), "ReserveGroupView header should appear for Monthly Bills")
    }

    @MainActor
    func testReserveGroupSheet_CancelDismisses() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-UITestBridge"]
        app.launch()

        // Prefer database-backed count via debug bridge when available
        var baselineCount: Int
        if ProcessInfo.processInfo.arguments.contains("-UITestBridge") {
            baselineCount = try XCTUnwrap(debugAllTransactionsCount(app), "Bridge baseline count unavailable")
        } else {
            baselineCount = try XCTUnwrap(allTransactionsApproxCount(app), "Could not determine baseline transactions count")
        }

        openReserveGroupSheet(app, groupName: "Monthly Bills")

        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5.0))
        cancelButton.tap()

        // Header should disappear after dismiss
        let header = app.staticTexts["Reserve Transactions: Monthly Bills"]
        XCTAssertFalse(header.waitForExistence(timeout: 2.0))

        // Give UI a brief moment to settle
        sleep(1)

        var afterCount: Int
        if ProcessInfo.processInfo.arguments.contains("-UITestBridge") {
            afterCount = try XCTUnwrap(debugAllTransactionsCount(app), "Bridge after count unavailable")
        } else {
            afterCount = try XCTUnwrap(allTransactionsApproxCount(app), "Could not determine transactions count after cancel")
        }

        XCTAssertEqual(afterCount, baselineCount, "Transactions should be unchanged after tapping Cancel")
    }

    @MainActor
    func testReserveGroupSheet_ReserveDismisses() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-UITestBridge"]
        app.launch()

        openReserveGroupSheet(app, groupName: "Monthly Bills")

        let reserveButton = app.buttons["Reserve"]
        XCTAssertTrue(reserveButton.waitForExistence(timeout: 5.0))
        reserveButton.tap()

        // Header should disappear after dismiss
        let header = app.staticTexts["Reserve Transactions: Monthly Bills"]
        XCTAssertFalse(header.waitForExistence(timeout: 2.0))
    }

    // MARK: - Helpers
    private func openReserveGroupSheet(_ app: XCUIApplication, groupName: String) {
        // Assumes Dashboard is the starting view. If not, navigate as needed here.
        // Wait for the Recurring Debits section to ensure the panel is visible.
        _ = app.staticTexts["Recurring Debits"].waitForExistence(timeout: 5.0)

        // Try tapping a button with the group name first
        if app.buttons[groupName].waitForExistence(timeout: 2.0) {
            tapElement(app.buttons[groupName])
            return
        }
        // Fall back to static text with the group name
        if app.staticTexts[groupName].waitForExistence(timeout: 2.0) {
            tapElement(app.staticTexts[groupName])
            return
        }
        // Final fallback: any element whose label contains the group name
        let anyMatch = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", groupName)).element(boundBy: 0)
        XCTAssertTrue(anyMatch.waitForExistence(timeout: 3.0), "Could not find recurring group named \(groupName)")
        tapElement(anyMatch)
    }

    private func tapElement(_ element: XCUIElement) {
        if element.isHittable {
            element.tap()
        } else {
            let coord = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coord.tap()
        }
    }

    // Helper: Approximate total transactions visible on Dashboard by summing reserved + pending
    private func allTransactionsApproxCount(_ app: XCUIApplication) -> Int? {
        // Try identifier-based lists first
        let reservedList = app.descendants(matching: .any)["ReservedTransactionsList"]
        let pendingList = app.descendants(matching: .any)["PendingTransactionsList"]

        var reservedCount = 0
        var pendingCount = 0

        if reservedList.waitForExistence(timeout: 2.0) {
            reservedCount = countRows(in: reservedList)
        } else {
            // Fallback: find a table containing the header
            let table = app.tables.containing(.staticText, identifier: "Reserved Transactions").element
            if table.waitForExistence(timeout: 2.0) {
                reservedCount = table.cells.count
                if reservedCount == 0 { reservedCount = table.descendants(matching: .tableRow).count }
            }
        }

        if pendingList.waitForExistence(timeout: 2.0) {
            pendingCount = countRows(in: pendingList)
        } else {
            let table = app.tables.containing(.staticText, identifier: "Pending Transactions").element
            if table.waitForExistence(timeout: 2.0) {
                pendingCount = table.cells.count
                if pendingCount == 0 { pendingCount = table.descendants(matching: .tableRow).count }
            }
        }

        // Always return a non-nil count, even if zero
        return reservedCount + pendingCount
    }
    
    // Count rows within a list-like container across platforms
    private func countRows(in container: XCUIElement) -> Int {
        // Prefer cells if available (iOS/macOS tables)
        let cellCount = container.descendants(matching: .cell).count
        if cellCount > 0 { return cellCount }
        // Try table rows (macOS tables)
        let tableRowCount = container.descendants(matching: .tableRow).count
        if tableRowCount > 0 { return tableRowCount }
        // Fallback: many of your rows are Buttons wrapping the row content
        let buttonCount = container.descendants(matching: .button).count
        if buttonCount > 0 { return buttonCount }
        // Last resort: count static texts (very rough)
        let labelCount = container.descendants(matching: .staticText).count
        return labelCount
    }

    // MARK: - Debug data bridge (reads counts from app)
    private func debugAllTransactionsCount(_ app: XCUIApplication) -> Int? {
        // Ensure the bridge button is present (app must be launched with -UITestBridge)
        let dumpButton = app.buttons["UITest_DumpCounts"]
        guard dumpButton.waitForExistence(timeout: 5.0) else { return nil }
        dumpButton.tap()
        // Read from pasteboard (macOS) or a label if provided; here we assume macOS
        #if os(macOS)
        let pb = NSPasteboard.general
        guard let str = pb.string(forType: .string) else { return nil }
        if let data = str.data(using: .utf8),
           let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let count = obj["allTransactions"] as? Int {
            return count
        }
        #endif
        return nil
    }
}
