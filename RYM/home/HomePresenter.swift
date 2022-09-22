//
//  HomePresenter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import UIKit

// MARK: - Basic class for navigation
final class HomePresenter: BasePresenter {
    static let shared = HomePresenter()

    weak var navigationController: UINavigationController?

    private init() {}
}
