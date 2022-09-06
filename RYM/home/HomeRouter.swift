//
//  HomeRouter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import Foundation
import SwiftUI

final class HomeRouter: BaseRouter, ObservableObject {
    static let shared = HomeRouter()

    weak var navigationController: UINavigationController?

    private init() {}

    func reset() {
        popToRoot()
        dissmisToRoot()
    }
}
