//
//  UIApplication {.swift
//  RYM
//
//  Created by Yauheni Skiruk on 5.10.22.
//

import UIKit

extension UIApplication {
    static var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }

    static var window: UIWindow? {
        appDelegate?.window
    }

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
