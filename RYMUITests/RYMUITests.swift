//
//  RYMUITests.swift
//  RYMUITests
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import XCTest

class RYMUITests: XCTestCase {

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
        XCTAssert(addButton.waitForExistence(timeout: 10))
//        addButton.tap()

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
