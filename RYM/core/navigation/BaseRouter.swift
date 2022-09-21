//
//  BaseRouter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit

/// This is a protocol for navigation in project
protocol BaseRouter {
    var navigationController: UINavigationController? { get set }

    func push<V: View>(view: V, animated: Bool)
    func pop()
    func popToRoot()
    func present<V: View>(view: V, transition: UIModalTransitionStyle)
    func dissmis(animated: Bool, completion: (() -> Void)?)
    func dissmisToRoot()
}

extension BaseRouter {
    /**
     Implement custom navigation controller
     */
    var topVC: UIViewController? {
        var topVC = navigationController?.topViewController
        while let topPresentedVC = topVC?.presentedViewController {
            topVC = topPresentedVC
        }
        return topVC
    }
    /**
     Function for push new View in App Navigation
     */
    func push<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        navigationController?.pushViewController(viewController, animated: animated)
    }
    /**
     Function for push new Views in App Navigation
     */
    func push<V: View>(views: [V], animated: Bool = false) {
        var controllers = navigationController?.viewControllers ?? []
        views.forEach { view in
            controllers.append(UIHostingController(rootView: view))
        }
        navigationController?.setViewControllers(controllers, animated: animated)
    }
    /**
     Function for pop to previous view in App Navigation
     */
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    /**
     Function for pop to root view in App Navigation
     */
    func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }
    /**
     Function for present new View in App Navigation with crossDissolve transition
     */
    func present<V: View>(view: V, transition: UIModalTransitionStyle = .crossDissolve) {
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = transition
        topVC?.present(viewController, animated: true)
    }
    /**
     Function for dismiss from current  View in App Navigation
     */
    func dissmis(animated _: Bool = true, completion: (() -> Void)? = nil) {
        topVC?.dismiss(animated: true, completion: completion)
    }
    /**
     Function for dismiss to root from current  View in App Navigation
     */
    func dissmisToRoot() {
        navigationController?.topViewController?.dismiss(animated: false)
    }
}
