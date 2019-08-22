//
//  MyPurchaseProducts.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2019/1/7.
//  Copyright © 2019 SEAN. All rights reserved.
//

import Foundation
import StoreKit

class MyPurchaseProducts {
    
    static let productIDs = ["auto_renewing_month_subscription", "non_renewing_yearly_subscription"]
    public static let store = IAPHelper(productIDs: productIDs)
    
}

class IAPHelper: NSObject, SKProductsRequestDelegate {
    
    var productIDs: Set<String> = []
    private var productsRequest: SKProductsRequest?
    
    init(productIDs: [String]) {
        for id in productIDs {
            self.productIDs.insert(id)
        }
    }

    public func requestProducts() {
        if SKPaymentQueue.canMakePayments() {
            productsRequest?.cancel()
            let productIdentifiers = productIDs
            for id in productIdentifiers {
                print(id)
            }
            productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productsRequest!.delegate = self
            productsRequest!.start()
        }
        else {
            print("Cannot perform In App Purchases")
        }

    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        clearRequest()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        clearRequest()
    }
    
    private func clearRequest() {
        productsRequest = nil
    }
}
