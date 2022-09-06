//
//  BaseRouter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit

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
    var topVC: UIViewController? {
        var topVC = navigationController?.topViewController
        while let topPresentedVC = topVC?.presentedViewController {
            topVC = topPresentedVC
        }
        return topVC
    }

    func push<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func push<V: View>(views: [V], animated: Bool = false) {
        var controllers = navigationController?.viewControllers ?? []
        views.forEach { view in
            controllers.append(UIHostingController(rootView: view))
        }
        navigationController?.setViewControllers(controllers, animated: animated)
    }

    func pop() {
        navigationController?.popViewController(animated: true)
    }

    func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }

    func present<V: View>(view: V, transition: UIModalTransitionStyle = .crossDissolve) {
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = transition
        topVC?.present(viewController, animated: true)
    }

    func dissmis(animated _: Bool = true, completion: (() -> Void)? = nil) {
        topVC?.dismiss(animated: true, completion: completion)
    }

    func dissmisToRoot() {
        navigationController?.topViewController?.dismiss(animated: false)
    }
}
