//
//  SubscriptionReceiptValidator.swift
//  RYM
//
//  Created by Yauheni Skiruk on 18.08.23.
//

import Foundation
import SwiftyReceiptValidator

class SubscriptionReceiptValidator {

    let receiptValidator: SwiftyReceiptValidatorType

    init() {
        let configuration = SRVConfiguration(
            productionURL: "https://buy.itunes.apple.com/verifyReceipt",
            sandboxURL: "https://sandbox.itunes.apple.com/verifyReceipt",
            sessionConfiguration: .default
        )

        receiptValidator = SwiftyReceiptValidator(configuration: configuration, isLoggingEnabled: false)
    }

    func validateReceipt(completion: @escaping (Bool) -> Void) {


        let validationRequest = SRVSubscriptionValidationRequest(
            sharedSecret: "146d41359be84f42ab52ea5250f762c6",
            refreshLocalReceiptIfNeeded: false,
            excludeOldTransactions: false,
            now: Date()
        )

        receiptValidator.validate(validationRequest) { result in
            switch result {

            case .success(let response):
                print(response.receiptResponse) // full receipt response
                print(response.validSubscriptionReceipts) // convenience array for active subscription receipts

                // Check the validSubscriptionReceipts and unlock products accordingly
                // or disable features if no active subscriptions are found e.g.
                completion(true)
                if response.validSubscriptionReceipts.isEmpty {
                    completion(false)
                    // disable subscription features etc
                } else {
                    completion(false)

                    // Valid subscription receipts are sorted by latest expiry date
                    // enable subscription features etc
                }

            case .failure(let error):
                switch error {
                case .noReceiptFoundInBundle:
                    break
                    // do nothing, see description below
                case .subscriptioniOS6StyleExpired(let statusCode):
                    // Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
                    // This receipt is valid but the subscription has expired.
                    print("error statusCode : \(String(describing: statusCode))")
                    completion(false)
                    break
                    // disable subscription features
                default: break
                    // do nothing or inform user of error during validation e.g UIAlertController
                }
            }
        }
    }
}
