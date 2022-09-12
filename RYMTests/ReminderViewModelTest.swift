//
//  ReminderViewModelTest.swift
//  RYMTests
//
//  Created by Yauheni Skiruk on 12/09/2022.
//

import XCTest
@testable import RYM

class ReminderViewModelTest: XCTestCase {
    var sut: RemainderViewModel!


    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RemainderViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResetData() throws {
        sut.title = "testTitle"
        sut.remainderColor = "Card-9"
        sut.weekDays = ["one", "two"]
        sut.isRemainderOn = true
        sut.remainderText = "reminderText"
        sut.remainderDate = Date(timeIntervalSince1970: 1234535)
        sut.editRemainder = MedicineRemainder()
        sut.notificationsIds = ["wdwdw", "dwdwdw"]

        sut.resetData()

        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.remainderColor, "Card-1")
        XCTAssertEqual(sut.weekDays, [])
        XCTAssertEqual(sut.isRemainderOn, false)
        XCTAssertEqual(sut.remainderText, "")
        XCTAssertEqual(sut.editRemainder, nil)
        XCTAssertEqual(sut.notificationsIds, [])

        let expectedDateTimeInterval = Date.timeIntervalSinceReferenceDate
        XCTAssertEqual(sut.remainderDate.timeIntervalSinceReferenceDate, expectedDateTimeInterval, accuracy: 0.001)

    }

//    func testRestoreEditingData() {
//        var editReminder = MedicineRemainder(
//        editReminder.title = "Edit Reminder title"
//        editReminder.color = "Card-5"
//        editReminder.weekDays = ["two, four"]
//        editReminder.isRemainderOn = true
//        editReminder.remainderText = "Edit remainder Text"
//        editReminder.notificationDate = Date(timeIntervalSince1970: 19992)
//        editReminder.notificationIDs = ["1111", "2222"]
//
//        sut.restoreEditingData()
//
//        XCTAssertEqual(sut.title, editReminder.title)
//        XCTAssertEqual(sut.remainderColor, editReminder.color)
//        XCTAssertEqual(sut.weekDays, editReminder.weekDays)
//        XCTAssertEqual(sut.isRemainderOn, editReminder.isRemainderOn)
//        XCTAssertEqual(sut.remainderText, editReminder.remainderText)
//        XCTAssertEqual(sut.notificationsIds, editReminder.notificationIDs)
//
//        let expectedDateTimeInterval = editReminder.notificationDate?.timeIntervalSinceReferenceDate
//        XCTAssertEqual(sut.remainderDate.timeIntervalSinceReferenceDate, expectedDateTimeInterval!, accuracy: 0.001)
//    }

    func testDoneStatusTrue() {
        var status = true

        sut.isRemainderOn = true
        sut.title = "aaa"
        sut.remainderText = "dwdwd"
        sut.weekDays = ["dwdw"]

        status = sut.doneStatus()

        XCTAssertEqual(status, true)
    }

    func testDoneStatusRemainderOff() {
        var status = true

        sut.isRemainderOn = false
        sut.title = "aaa"
        sut.remainderText = "dwdwd"
        sut.weekDays = ["dwdw"]

        status = sut.doneStatus()

        XCTAssertEqual(status, true)
    }

    func testDoneStatusTitleEmpty() {
        var status = true

        sut.isRemainderOn = true
        sut.title = ""
        sut.remainderText = "dwdwd"
        sut.weekDays = ["dwdw"]

        status = sut.doneStatus()

        XCTAssertEqual(status, false)
    }

    func testDoneStatusRemainderTextEmpty() {
        var status = true

        sut.isRemainderOn = true
        sut.title = "dwdw"
        sut.remainderText = ""
        sut.weekDays = ["dwdw"]

        status = sut.doneStatus()

        XCTAssertEqual(status, false)
    }

    func testDoneStatusWeekDaysEmpty() {
        var status = true

        sut.isRemainderOn = true
        sut.title = "dwdw"
        sut.remainderText = "dwdwd"
        sut.weekDays = []

        status = sut.doneStatus()

        XCTAssertEqual(status, false)
    }

    func testDoneStatusAllFaulse() {
        var status = true

        sut.isRemainderOn = false
        sut.title = ""
        sut.remainderText = ""
        sut.weekDays = []

        status = sut.doneStatus()

        XCTAssertEqual(status, false)
    }

    func testCreateIds() {
        sut.notificationsIds = []
        sut.weekDays = ["Monday", "Tuesday", "Friday"]

        sut.sheduleNotificationsAndCreateIds()

        XCTAssertEqual(sut.notificationsIds.count, 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
