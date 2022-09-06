//
//  BasePresenter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit

struct AlertInfo {
    let title: String? = nil
    let message: String? = nil
    var buttons: [Button]

    struct Button {
        var title: String
        var style: UIAlertAction.Style = .default
        var action: () -> Void
    }
}

protocol BasePresenter {
    var navigationController: UINavigationController? { get set }

    func show(alert: AlertInfo)
    func show(actionSheet: AlertInfo)
}

extension BasePresenter {
    private var topVC: UIViewController? {
        var topVC = navigationController?.topViewController
        while let topPresentedVC = topVC?.presentedViewController {
            topVC = topPresentedVC
        }
        return topVC
    }

    func show(alert: AlertInfo) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alert.buttons.forEach { button in
            let alertAction = UIAlertAction(title: button.title,
                                            style: button.style,
                                            handler: { _ in button.action() })
            alertController.addAction(alertAction)
        }
        topVC?.present(alertController, animated: true)
    }

    func show(actionSheet: AlertInfo) {
        let alertController = UIAlertController(title: actionSheet.title,
                                                message: actionSheet.message,
                                                preferredStyle: .actionSheet)
        actionSheet.buttons.forEach { button in
            let alertAction = UIAlertAction(title: button.title,
                                            style: button.style,
                                            handler: { _ in button.action() })
            alertController.addAction(alertAction)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        topVC?.present(alertController, animated: true)
    }
}
