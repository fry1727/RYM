//
//  CoreDataTest.swift
//  RYMTests
//
//  Created by Yauheni Skiruk on 13.09.22.
//

import XCTest
@testable import RYM
import CoreData

class CoreDataTest: XCTestCase {
    var viewModel: RemainderViewService!
    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = CoreDataStack()
        viewModel = RemainderViewService()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        coreDataStack = nil
    }

    func testResultAddRemainder() throws {
        let context = coreDataStack.persistentContainer.viewContext

        let result = viewModel.addRemainder(context: context)
        XCTAssertEqual(result, true)
    }

    func testAddRemainder() throws {
        let title = ""
        let remainderColor = "Card-1"
        let weekDays: [String] = []
        let isRemainderOn = false
        let remainderText = ""
        let notificationsIds: [String] = []

        let expectations = expectation(description: "waiting")

        let context = coreDataStack.persistentContainer.viewContext

        _ = viewModel.addRemainder(context: context)

        let fetchRequest: NSFetchRequest<MedicineRemainder> = MedicineRemainder.fetchRequest()

        coreDataStack.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                XCTAssertEqual(result.first?.title, title)
                XCTAssertEqual(result.first?.color, remainderColor)
                XCTAssertEqual(result.first?.weekDays, weekDays)
                XCTAssertEqual(result.first?.isRemainderOn, isRemainderOn)
                XCTAssertEqual(result.first?.remainderText, remainderText)
                XCTAssertEqual(result.first?.notificationIDs, notificationsIds)
                expectations.fulfill()
            } catch {
                print("error")
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testDeleteRemainder() throws {
        let context = coreDataStack.persistentContainer.viewContext

        let expectations = expectation(description: "waiting")

        _ = viewModel.deleteRemainder(context: context)

        let fetchRequest: NSFetchRequest<MedicineRemainder> = MedicineRemainder.fetchRequest()

        coreDataStack.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                XCTAssertEqual(result.first?.title, nil)
                XCTAssertEqual(result.first?.color, nil)
                XCTAssertEqual(result.first?.weekDays, nil)
                XCTAssertEqual(result.first?.isRemainderOn, nil)
                XCTAssertEqual(result.first?.remainderText, nil)
                XCTAssertEqual(result.first?.notificationIDs, nil)
                expectations.fulfill()
            } catch {
                print("error")
            }
        }
        waitForExpectations(timeout: 3)
    }

    func testRestoreEditingData() {
        let context = coreDataStack.persistentContainer.viewContext
        viewModel.editRemainder = MedicineRemainder(context: context)
        
        viewModel.title = "NewTitle"
        viewModel.remainderColor = "Card-9"
        viewModel.weekDays = ["one", "two"]
        viewModel.isRemainderOn = true
        viewModel.remainderText = "reminderText"
        viewModel.remainderDate = Date(timeIntervalSince1970: 1234535)
        viewModel.notificationsIds = ["wdwdw", "dwdwdw"]

        viewModel.restoreEditingData()

        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.remainderColor, "Card-1")
        XCTAssertEqual(viewModel.weekDays, [])
        XCTAssertEqual(viewModel.isRemainderOn, false)
        XCTAssertEqual(viewModel.remainderText, "")
        XCTAssertEqual(viewModel.notificationsIds, [])

        let expectedDateTimeInterval = Date.timeIntervalSinceReferenceDate
        XCTAssertEqual(viewModel.remainderDate.timeIntervalSinceReferenceDate, expectedDateTimeInterval, accuracy: 0.1)
    }

}
