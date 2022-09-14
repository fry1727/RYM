//
//  RYMUITests.swift
//  RYMUITests
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import XCTest

class MainScreenTests: XCTestCase {

    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testAddButtonExisted() throws {

        let app = XCUIApplication()
        app.launch()

        let addButton = app.scrollViews.otherElements.buttons["Add"]
        let reminderTitle = app.scrollViews.staticTexts["Remainders"]
        let mainText = app.staticTexts["There is no medicine remainders"]
        XCTAssert(mainText.waitForExistence(timeout: 3))
        XCTAssert(reminderTitle.waitForExistence(timeout: 3))
        XCTAssert(addButton.waitForExistence(timeout: 3))
    }
}
