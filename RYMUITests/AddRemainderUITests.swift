//
//  AddRemainderUITests.swift
//  RYMUITests
//
//  Created by Yauheni Skiruk on 14.09.22.
//

import XCTest

class AddRemainderUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let addButton = app.scrollViews.otherElements.buttons["Add"]
        addButton.tap()

        let navigationbar = app.navigationBars["Add Medicine Remainder"]
        let title = navigationbar.staticTexts["Add Medicine Remainder"]
        XCTAssert(title.waitForExistence(timeout: 3))

        let doneButton = navigationbar.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 3))

        let closeButton = navigationbar.buttons["Close"]
        XCTAssert(closeButton.waitForExistence(timeout: 3))

        let mondayButton = app.staticTexts["Mo"]
        XCTAssert(mondayButton.waitForExistence(timeout: 3))

        let titleTextField = app.textFields["Title"]
        XCTAssert(titleTextField.waitForExistence(timeout: 3))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
