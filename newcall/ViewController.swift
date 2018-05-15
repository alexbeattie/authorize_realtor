//
//  ViewController.swift
//  newcall
//
//  Created by Alex Beattie on 5/10/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
typealias JSON = [String: Any]
class ViewController: UIViewController {

    
    struct responseData: Decodable {
        var D: ResultsData
    }
    struct ResultsData: Decodable {
        var Results: [resultsArr]
    }
    struct resultsArr: Decodable {
        var AuthToken: String
        var Expires: String
    }
    
    struct listingsData: Decodable {
        var D: listingResultsData
    }
    struct listingResultsData: Decodable {
        var Results: [listingResultsArr]
    }
    struct listingResultsArr: Decodable {
//        var Id: String
//        var ResourceUri: String
        var StandardFields: [standardFields]
    }
    struct standardFields: Decodable {
        var ListAgentName: String
    }
    
    
    let myListingsPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken"
//    let call:String = "http://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"

    
    func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
    
    
    func dataRequest() {

        let baseUrl = URL(string: "https://sparkapi.com/v1/session?ApiKey=vc_c15909466_key_1&ApiSig=a2b8a9251df6e00bf32dd16402beda91")!
        let request = NSMutableURLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
           
            guard let data = data else { return }
    
            if let error = error {
                print(error)
            }
            do {
                let decoder = JSONDecoder()
                let listing = try decoder.decode(responseData.self, from: data)
                
                print(listing.D.Results)

                guard let authToken = listing.D.Results[0].AuthToken as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                var myListingsPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken"
                myListingsPass.append(authToken)
                print("The AuthToken is: " + myListingsPass)
                let apiSig = self.md5(myListingsPass)
                print(apiSig)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    completionHandler(listing)
                    var call = "http://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
                    print(call)
                    var newCallUrl = URL(string: call)
                    let request = NSMutableURLRequest(url: newCallUrl!)
                    request.httpMethod = "GET"
                    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                    request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
                    let newTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                        guard let data = data else { return }
                            print(data)
                                    if let error = error {
                                        print(error)
                                    }
                                    do {
                                        let newDecoder = JSONDecoder()
//                                        let theCall = try newDecoder.decode(listingResultsArr.self, from: data)
                                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else { return }
                                        print(json)
//                                        print("This is + \(theCall.StandardFields.count)")
                        
                        
//                                            print(theCall)
                        
                                    } catch let err {
                                        print(err)
                                    }
                                }
                    
                                newTask.resume()
                
                    
            
//                DispatchQueue.main.async(execute: { () -> Void in
//                    completionHandler(listing)
////                    print(call)
//
//                })
            } catch let err {
                print(err)
            }
        }
     
        task.resume()
    }
    
    
    
//    func listingsCall(withString: String )  {
//        let withString = call
//        let newCallUrl = URL(string: call)
//        let request = NSMutableURLRequest(url: newCallUrl!)
//        request.httpMethod = "GET"
//        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
//        request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
//
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//
//            guard let data = data else { return }
//
//            if let error = error {
//                print(error)
//            }
//            do {
//                let decoder = JSONDecoder()
//                let theCall = try decoder.decode(responseData.self, from: data)
//
//                print(theCall.D.Results)
//
//
////                DispatchQueue.main.async(execute: { () -> Void in
////                    completionHandler(theCall)
//                    print(theCall)
//
////                })
//            } catch let err {
//                print(err)
//            }
//        }
//
//        task.resume()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRequest()

        
        

           
    }

}

