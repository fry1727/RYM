//
//  BasePresenter.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit

/**
 This is a struct for creating alerts in project
 */
struct AlertInfo {
    let title: String?
    let message: String?
    var buttons: [Button]

    struct Button {
        var title: String
        var style: UIAlertAction.Style = .default
        var action: () -> Void
    }
}

/// This is a protocol for working with alerts and action sheets in project
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
    /**
     This is a func for show alerts in project
     ### Usage Example: ###
     ````
     HomePresenter.shared.show(alert: alert)
     ````
     */
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
    /**
     This is a func for show actionSheet in project
     */
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
