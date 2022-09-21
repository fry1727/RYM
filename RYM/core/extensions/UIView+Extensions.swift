//
//  UIView+Extensions.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import UIKit

/// This is a extension for UIView that allow use height and width of screen easly
/// and allow to work with edges of frame
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return left + width
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }
}
