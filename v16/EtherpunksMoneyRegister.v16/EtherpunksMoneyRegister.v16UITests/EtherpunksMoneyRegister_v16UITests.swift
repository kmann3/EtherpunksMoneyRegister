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

    @MainActor
    func testEditBasicFieldsAndSavePersists() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to the AccountTransactionEditView for a known transaction
        navigateToEditView(app)

        // Change Name
        let nameField = app.textFields["Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2.0))
        nameField.tap()
        nameField.clearAndType("Groceries - Weekly")

        // Change Amount
        let amountField = app.textFields["Amount"]
        XCTAssertTrue(amountField.exists)
        amountField.tap()
        amountField.clearAndType("42.35")

        // Change Type to Credit (menu-style picker appears as a button)
        let typeMenu = app.buttons["Type"]
        if typeMenu.exists {
            typeMenu.tap()
            let creditOption = app.buttons["Credit"]
            if creditOption.waitForExistence(timeout: 1.0) {
                creditOption.tap()
            }
        }

        // Toggle Tax Related
        let taxToggle = app.switches["Tax Related"]
        if taxToggle.exists { taxToggle.tap() }

        // Save
        let saveButton = app.navigationBars.buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        // Verify we returned to detail and new name is displayed
        XCTAssertTrue(app.staticTexts["Name: Groceries - Weekly"].waitForExistence(timeout: 3.0))
        // Optionally assert type text on detail if shown as plain text
        XCTAssertTrue(app.staticTexts["Type: Credit"].exists)
    }

    @MainActor
    func testToggleDatesPersistAfterSave() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to the AccountTransactionEditView
        navigateToEditView(app)

        // Toggle Pending, Cleared, Has Due Date
        let pendingToggle = app.switches["Pending"]
        XCTAssertTrue(pendingToggle.waitForExistence(timeout: 2.0))
        pendingToggle.tap()

        let clearedToggle = app.switches["Cleared"]
        XCTAssertTrue(clearedToggle.exists)
        clearedToggle.tap()

        let dueToggle = app.switches["Has Due Date"]
        XCTAssertTrue(dueToggle.exists)
        dueToggle.tap()

        // Date pickers should appear
        XCTAssertTrue(app.datePickers["Pending On"].waitForExistence(timeout: 1.0))
        XCTAssertTrue(app.datePickers["Cleared On"].exists)
        XCTAssertTrue(app.datePickers["Due Date"].exists)

        // Save changes
        let saveButton = app.navigationBars.buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        // Back on detail screen: tap Edit Transaction to return to edit view
        let editButton = app.buttons["Edit Transaction"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 3.0))
        editButton.tap()

        // Verify the toggles persisted (date pickers visible again)
        XCTAssertTrue(app.datePickers["Pending On"].waitForExistence(timeout: 2.0))
        XCTAssertTrue(app.datePickers["Cleared On"].exists)
        XCTAssertTrue(app.datePickers["Due Date"].exists)
    }

    // MARK: - Helpers
    private func navigateToEditView(_ app: XCUIApplication) {
        // TODO: Replace with your app's real navigation.
        // Suggested pattern:
        // app.buttons["Transactions"].tap()
        // app.cells["TransactionRow_CVS"].tap()
        // app.buttons["Edit Transaction"].tap()
    }
}
private extension XCUIElement {
    func clearAndType(_ text: String) {
        tap()
        if let stringValue = self.value as? String, !stringValue.isEmpty {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            typeText(deleteString)
        }
        typeText(text)
    }
}

