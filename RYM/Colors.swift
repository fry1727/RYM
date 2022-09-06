//
//  Colors.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit

enum AppColor: String {
    /// #FFFFFF
    case background
    /// #000000

}

extension Color {
    static func getColor(_ name: AppColor) -> Color {
        if UIColor(named: name.rawValue) != nil {
            return Color(name.rawValue)
        } else {
            print("There is no such color in plist \(name.rawValue)")
            return .clear
        }
    }

    init(_ name: AppColor) {
        self = Self.getColor(name)
    }
}

extension UIColor {
    static func getColor(_ name: AppColor) -> UIColor {
        if let color = UIColor(named: name.rawValue) {
            return color
        } else {
            print("There is no such color in plist \(name.rawValue)")
            return .clear
        }
    }
}
