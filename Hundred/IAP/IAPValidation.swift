////
////  IAPValidation.swift
////  Hundred
////
////  Created by J C on 2020-10-03.
////  Copyright © 2020 J. All rights reserved.
////
//
///*
// Abstract:
// Validates the App Store receipt by sending it to a certain endpoint and analyzing the returned data to see
// if the expiry date for the auto-renewable subscription has expired
//
// */
//
//
//import Foundation
//import StoreKit
//
//class IAPValidation {
//    struct Endpoint {
//        static let sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
//        static let itunes = "https://buy.itunes.apple.com/verifyReceipt"
//    }
//
//    fileprivate let appStoreReceiptURL = Bundle.main.appStoreReceiptURL
//    
//    func getAppReceipt() {
//        if let appStoreReceiptURL = appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
//            do {
//                let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
//                try validateReceipt(receiptData)
//            } catch ReceiptValidationError.receiptNotFound {
//                // There is no receipt on the device 😱
//                print("There is no receipt on the device")
//                let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
//                appReceiptRefreshRequest.delegate = self
//                appReceiptRefreshRequest.start()
//                // If all goes well control will land in the requestDidFinish() delegate method.
//                // If something bad happens control will land in didFailWithError.
//            } catch ReceiptValidationError.jsonResponseIsNotValid(let description) {
//                // unable to parse the json 🤯
//                print("unable to parse the json \(description)")
//            } catch ReceiptValidationError.notBought {
//                // the subscription hasn't being purchased 😒
//                print("the subscription hasn't being purchased")
//            } catch ReceiptValidationError.expired {
//                // the subscription is expired 😵
//                print("the subscription is expired")
//            } catch {
//                print("Unexpected error: \(error).")
//            }
//        }
//    }
//
//    func validateReceipt(_ receiptData: Data) {
//
//        let base64encodedReceipt = receiptData.base64EncodedString()
//        let requestDictionary = ["receipt-data":base64encodedReceipt]
//        guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
//            #if DEBUG
//            let validationURLString = Endpoint.sandbox
//            #else
//            let validationURLString = Endpoint.itunes
//            #endif
//            guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            var request = URLRequest(url: validationURL)
//            request.httpMethod = "POST"
//            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
//            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
//                if let data = data , error == nil {
//                    do {
//                        let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
//                        print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
//                        // if you are using your server this will be a json representation of whatever your server provided
//                    } catch let error as NSError {
//                        print("json serialization failed with error: \(error)")
//                    }
//                } else {
//                    print("the upload task returned an error: \(error)")
//                }
//            }
//            task.resume()
//        } catch let error as NSError {
//            print("json serialization failed with error: \(error)")
//        }
//    }
//
////    func validateReceipt(_ receiptData: Data) throws {
////        let receiptString = receiptData.base64EncodedString()
////        let jsonObjectBody = ["receipt-data" : receiptString]
////
////        #if DEBUG
////        let url = URL(string: Endpoint.sandbox)!
////        #else
////        let url = URL(string: Endpoint.itunes)!
////        #endif
////
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObjectBody, options: .prettyPrinted)
////
////        let semaphore = DispatchSemaphore(value: 0)
////
////        var validationError : ReceiptValidationError?
////
////        let task = URLSession.shared.dataTask(with: request) { data, response, error in
////            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else {
////                validationError = ReceiptValidationError.jsonResponseIsNotValid(description: error?.localizedDescription ?? "")
////                semaphore.signal()
////                return
////            }
////            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
////                validationError = ReceiptValidationError.jsonResponseIsNotValid(description: "Unable to parse json")
////                semaphore.signal()
////                return
////            }
////            guard let expirationDate = self.expirationDate(jsonResponse: jsonResponse, forProductId: "com.noName.Hundred6months") else {
////                validationError = ReceiptValidationError.notBought
////                semaphore.signal()
////                return
////            }
////
////            let currentDate = Date()
////            if currentDate > expirationDate {
////                validationError = ReceiptValidationError.expired
////            }
////
////            semaphore.signal()
////        }
////        task.resume()
////
////        semaphore.wait()
////
////        if let validationError = validationError {
////            throw validationError
////        }
////    }
//
//    func expirationDate(jsonResponse: [AnyHashable: Any], forProductId productId :String) -> Date? {
//        guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else {
//            return nil
//        }
//
//        print("receiptInfo: \(receiptInfo)")
////        let filteredReceipts = receiptInfo.filter{ return ($0["product_id"] as? String) == productId }
////
////        guard let lastReceipt = filteredReceipts.last else {
////            return nil
////        }
//
//        guard let lastReceipt = receiptInfo.last else {
//            return nil
//        }
//
//        print("lastReceipt: \(lastReceipt)")
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
//
//        if let expiresString = lastReceipt["expires_date"] as? String {
//            print("expiresString: \(expiresString)")
//
//            return formatter.date(from: expiresString)
//        }
//
//        return nil
//    }
//
//    func requestDidFinish(_ request: SKRequest) {
//        // a fresh receipt should now be present at the url
//        do {
//            let receiptData = try Data(contentsOf: appStoreReceiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
//            try validateReceipt(receiptData)
//        } catch {
//            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
//        }
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("app receipt refresh request did fail with error: \(error)")
//        // for some clues see here: https://samritchie.net/2015/01/29/the-operation-couldnt-be-completed-sserrordomain-error-100/
//    }
//}
//
//
//
//
//
//
//
////func validateReceipt(_ receipt: Data) throws {
//////        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
//////            throw ReceiptValidationError.receiptNotFound
//////        }
////
////    let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
////    let receiptString = receiptData.base64EncodedString()
////    let jsonObjectBody = ["receipt-data" : receiptString]
////
////    #if DEBUG
////    let url = URL(string: Endpoint.sandbox)!
////    #else
////    let url = URL(string: Endpoint.itunes)!
////    #endif
////
////    var request = URLRequest(url: url)
////    request.httpMethod = "POST"
////    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObjectBody, options: .prettyPrinted)
////
////    let semaphore = DispatchSemaphore(value: 0)
////
////    var validationError : ReceiptValidationError?
////
////    let task = URLSession.shared.dataTask(with: request) { data, response, error in
////        guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else {
////            validationError = ReceiptValidationError.jsonResponseIsNotValid(description: error?.localizedDescription ?? "")
////            semaphore.signal()
////            return
////        }
////        guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
////            validationError = ReceiptValidationError.jsonResponseIsNotValid(description: "Unable to parse json")
////            semaphore.signal()
////            return
////        }
////        guard let expirationDate = self.expirationDate(jsonResponse: jsonResponse, forProductId: "com.noName.Hundred6months") else {
////            validationError = ReceiptValidationError.notBought
////            semaphore.signal()
////            return
////        }
////
////        let currentDate = Date()
////        if currentDate > expirationDate {
////            validationError = ReceiptValidationError.expired
////        }
////
////        semaphore.signal()
////    }
////    task.resume()
////
////    semaphore.wait()
////
////    if let validationError = validationError {
////        throw validationError
////    }
////}
