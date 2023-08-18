//
//  SubscriptionService.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import Combine
import Foundation
import StoreKit

enum PurchaseError: Error {
    case cannotMakePurchases
    case transactionFailed
    case cannotGetReceipt
    case cannotUploadReceipt
    case cannotGetProfile
    case nothingToRestore
    case canceled
    case unknown

    var isOurSideError: Bool {
        self == .cannotGetReceipt || self == .cannotUploadReceipt || self == .cannotGetProfile
    }
}

final class SubscriptionService: NSObject, ObservableObject {
    typealias Completion = (Result<Void, PurchaseError>) -> Void

    static let shared = SubscriptionService()
    private var cancellables: [AnyCancellable] = []

    @Published var purchaseProducts: [ProductSubscription] = []
    private var restoringPurchaseIds: [String] = []

    private var purchaseCompletion: Completion?
    private var restoreCompletion: Completion?

    func initialize() {
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }

    private func fetchProducts() {
        let productIdentifiers = Set(ProductSubscription.allIdentifiers)
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func purchase(_ purchaseProduct: ProductSubscription, completion: @escaping Completion) {
        purchaseProduct.onPurchaseStarted?()
        guard SKPaymentQueue.canMakePayments() else {
            return completion(.failure(.cannotMakePurchases))
        }

        purchaseCompletion = completion
        let payment = SKPayment(product: purchaseProduct.product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases(completion: @escaping Completion) {
        restoreCompletion = completion
        restoringPurchaseIds = []
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func onPurchaseCompletion(_ result: Result<Void, PurchaseError>) {
        purchaseCompletion?(result)
        purchaseCompletion = nil
        if case let .failure(error) = result, error.isOurSideError {
        }
    }

    private func onRestoreCompletion(_ result: Result<Void, PurchaseError>) {
        restoreCompletion?(result)
        restoreCompletion = nil
        if case let .failure(error) = result, error.isOurSideError {
            print(error)
        }
    }
}

extension SubscriptionService: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
            .sorted(by: { Int(truncating: $0.price) > Int(truncating: $1.price) })
        let purchaseProducts = products.map { ProductSubscription(product: $0) }
        DispatchQueue.main.async {
            self.purchaseProducts = purchaseProducts
        }
    }

    func request(_: SKRequest, didFailWithError error: Error) {
        print(error)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchasing, .deferred:
                break
            case .purchased:
                print("transaction.payment.productIdentifier \(transaction.payment.productIdentifier)")
                purchaseProducts.forEach {
                    print("purchaseProducts.forEach id \($0.product.productIdentifier)")
                }

                purchaseProducts.forEach {
                    print("equal \($0.product.productIdentifier == transaction.payment.productIdentifier)")
                }

                let purchaseProduct = purchaseProducts
                    .first(where: { $0.product.productIdentifier == transaction.payment.productIdentifier })
                print("purchaseProduct \(purchaseProduct?.product.productIdentifier)")

                guard let purchaseProduct = purchaseProducts
                    .first(where: { $0.product.productIdentifier == transaction.payment.productIdentifier })
                else {
                    onPurchaseCompletion(.failure(.unknown))
                    return
                }
                uploadReceipt {
                    if case let .failure(error) = $0 {
                        self.onPurchaseCompletion(.failure(error))
                        return
                    }
                    if case let .success(value) = $0 {
                        purchaseProduct.onPurchaseFinished?(value)
                        self.onPurchaseCompletion(.success(()))
                        queue.finishTransaction(transaction)
                    }
                }
            case .failed:
                if (transaction.error as? NSError)?.code == SKError.paymentCancelled.rawValue {
                    onPurchaseCompletion(.failure(.canceled))
                } else {
                    onPurchaseCompletion(.failure(.transactionFailed))
                }
                queue.finishTransaction(transaction)
            case .restored:
                restoringPurchaseIds.append(transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
            @unknown default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_: SKPaymentQueue) {
        guard !restoringPurchaseIds.isEmpty else {
            onRestoreCompletion(.failure(.nothingToRestore))
            return
        }
        self.onRestoreCompletion(.success(()))
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
        onRestoreCompletion(.failure(.unknown))
    }

    func paymentQueue(_ queue: SKPaymentQueue, didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]) {
        print("didRevokeEntitlementsForProductIdentifiers \(productIdentifiers)")
    }
}

extension SubscriptionService {
    private var receipt: String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptString = try? Data(contentsOf: receiptURL).base64EncodedString()
        else {
            return nil
        }
        return receiptString
    }

    func uploadReceipt(completion: @escaping (Result<Float, PurchaseError>) -> Void) {
        guard let receipt = receipt else {
            completion(.failure(.cannotGetReceipt))
            return
        }
        print(receipt)
        completion(.success(1.1))
    }
}

