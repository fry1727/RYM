//
//  OnboardingViewModelTest.swift
//  RYMTests
//
//  Created by Yauheni Skiruk on 13.09.22.
//

import XCTest
import CoreData
@testable import RYM

class OnboardingViewModelTest: XCTestCase {
    var appConfig: AppConfig!
    var onboardingViewModel: OnboardingViewModel!
    weak var navigationController: UINavigationController?
    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = CoreDataStack()
        appConfig = AppConfig()
        onboardingViewModel = OnboardingViewModel(navController: navigationController, viewContext: coreDataStack.persistentContainer)
    }

    override func tearDownWithError() throws {
        appConfig = nil
        onboardingViewModel = nil
        coreDataStack = nil
    }

    func testLogin() throws {
        onboardingViewModel.loginUser()
        XCTAssertEqual(appConfig.isFinishOnboarding, true)
    }

    func testInit() throws {
       let testVM = OnboardingViewModel(navController: navigationController, viewContext: coreDataStack.persistentContainer)
        XCTAssertEqual(testVM.viewContext, onboardingViewModel.viewContext)
        XCTAssertEqual(testVM.router.navigationController, onboardingViewModel.router.navigationController)

    }

}
