//
//  OnboardingRouterTest.swift
//  RYMTests
//
//  Created by Yauheni Skiruk on 13.09.22.
//

import XCTest
@testable import RYM

class OnboardingRouterTest: XCTestCase {
    var router: OnboardingRouter!
    var navigationController: UINavigationController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        navigationController = NavigationController()
        router = OnboardingRouter(navController: navigationController)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testInit() throws {
        let routerTest = OnboardingRouter(navController: navigationController)
        XCTAssertEqual(routerTest.navigationController, router.navigationController)
    }

    func testSwipeToBack() throws {
        let testableSipe = true
        router.swipeToBack(testableSipe)
        let navController = router.navigationController as? NavigationController
        XCTAssertEqual(navController!.isSwipeToBackEnabled, testableSipe)
    }

}
