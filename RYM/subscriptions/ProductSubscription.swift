//
//  ProductSubscription.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import Foundation
import StoreKit

extension ProductSubscription {
    static let allIdentifiers = [
        "com.rym.1month",
    ]
}

struct ProductSubscription {
    let product: SKProduct
    var onPurchaseStarted: (() -> Void)?
    var onPurchaseFinished: ((Float) -> Void)?

    init(product: SKProduct) {
        self.product = product
    }
}
