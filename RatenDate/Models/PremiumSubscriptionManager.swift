import StoreKit

class PremiumSubscriptionManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private let premiumProductIdentifier = "com.yourapp.premiumsubscription"
    private var premiumProduct: SKProduct?

    // Function to make a user a premium subscriber
    func makeUserPremium() {
        requestProductInfo()
    }

    // Request product information
    private func requestProductInfo() {
        let productIdentifiers = Set([premiumProductIdentifier])
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }

    // SKProductsRequestDelegate method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            premiumProduct = product
            // Optionally present the purchase option to the user
            // buyProduct(product) can be called based on user action
        } else {
            // Handle the error (product not found or can't be purchased)
        }
    }

    // Function to initiate the purchase
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }

    // SKPaymentTransactionObserver methods
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchased:
                    completeTransaction(transaction)
                case .failed:
                    failedTransaction(transaction)
                case .restored:
                    restoreTransaction(transaction)
                default:
                    break
            }
        }
    }

    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        // Unlock premium content/features for the user
        // Then, finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError {
            // Handle the error, e.g., display an error message to the user
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        // Restore the previously purchased premium subscription
        // Then, finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
