//
//  AuthToken.swift
//  newcall
//
//  Created by Alex Beattie on 5/14/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import Foundation
import UIKit

class AuthToken: Codable {

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
    
    func dataRequest(_ completionHandler: @escaping (responseData) -> ()) {
    
        let baseUrl = URL(string: "https://sparkapi.com/v1/session?ApiKey=vc_c15909466_key_1&ApiSig=a2b8a9251df6e00bf32dd16402beda91")!
        let request = NSMutableURLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data else { return }
            print(data)
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
                //md5 test
                //print("The AuthToken is: " + self.md5(authToken))
                var myListingsPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken"
                myListingsPass.append(authToken)
                print("The AuthToken is: " + myListingsPass)
                let apiSig = self.md5(myListingsPass)
                print(apiSig)
                let call = "http://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
                print(call)
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
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
}

