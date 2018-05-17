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
    
    //listing struct
    struct listingData: Codable {
        var D: listingResultsData
    }
    struct listingResultsData: Codable {
        var Results: [listingResults]
    }
    struct listingResults: Codable {
        var Id: String
        var ResourceUri: String
        var StandardFields: standardFields
    }
    struct standardFields: Codable {
        
        var ListingId: String

        var ListAgentName: String
        var ListAgentStateLicense: String
        var ListAgentEmail: String

        var CoListAgentName: String
        var CoListAgentStateLicense: String
        var ListOfficePhone: String
        var ListOfficeFax: String

        var UnparsedFirstLineAddress: String
        var City: String
        var PostalCode: String
        var StateOrProvince: String

        var UnparsedAddress: String
        var YearBuilt: Int?

        var CurrentPricePublic: Int
        var ListPrice: Int

        var BedsTotal: Int
        var BathsFull: Int
        var BathsHalf: Int?

        var BuildingAreaTotal: Int

        var PublicRemarks: String?

        var ListAgentURL: String
        var ListOfficeName: String
        
        let Latitude: Double
        let Longitude: Double
     
    }
    
    //photo struct
    struct photoData: Codable {
        var D: photoResultsData
    }
    struct photoResultsData: Codable {
        var Results: [photoResults]
    }
    struct photoResults: Codable {
//        var Id: String
//        var ResourceUri: String
//        var Name: String
        var UriThumb: String
    }
    
    
    
    let myListingsPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken"
    
//    let myListingsPhotos = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/listings/<Listing.Id>/photosAuthToken"
//    let call:String = "http://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
    //    let call:String = "http://sparkapi.com/v1/listings/\(listingId)/photos?AuthToken=\(authToken)&ApiSig=\(apiSig)"

    
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
                print("The Pre MD5 /my/listings ApiSig is: " + myListingsPass)
                let apiSig = self.md5(myListingsPass)
                print("The Converted MD5 /my/listings: " + apiSig)
//                DispatchQueue.main.async(execute: { () -> Void in
//                    completionHandler(listing)
                    var call = "http://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
                    print("The Session Call is: " + call)
                    var newCallUrl = URL(string: call)
                    var request = URLRequest(url: newCallUrl!)
                    request.httpMethod = "GET"
                    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                    request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
                    let newTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                        guard let data = data else { return }
                            print(data)
                                    if let error = error {
//                                        print(error)
                                    }
                                    do {
                                        
                                        let newDecoder = JSONDecoder()
                                        
                                        var theCall = try newDecoder.decode(listingData.self, from: data)
//                                        let id = try newDecoder.decode([listingResults].self, from: data)
                                        
//                                        print(theCall.D.Results)

                                        
                                        for theId in theCall.D.Results {
                                            theCall.D.Results.append(theId)
                                            print(theCall.D.Results)

//                                            theCall.D.Results.append(Id)
                                            let newId = theId.Id

                                            print("The Listing.Id is: " + newId)
                                            var myPhotoPass:String = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/listings/\(newId)/photosAuthToken"
                                            myPhotoPass.append(authToken)
                                            print("The Photo Listing string before conversion Pre MD5 is: " + myPhotoPass)
                                            let newApiSig = self.md5(myPhotoPass)
                                            

                                            print(newApiSig)
                                            let photoCall:String = "http://sparkapi.com/v1/listings/\(newId)/photos?AuthToken=\(authToken)&ApiSig=\(newApiSig)"
                                            print("The PhotoUrl is: " + photoCall)
                                            ///MAKE REQUEST HERE
                                            //print("This is + \(theCall.D.Results)\n")
                                            var photoCallUrl = URL(string: photoCall)
                                            var request = URLRequest(url: photoCallUrl!)
                                            request.httpMethod = "GET"
                                            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                                            request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
                                            let photoTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                                                guard let data = data else { return }
                                                print(data)
                                                if let error = error {
                                                    //                                        print(error)
                                                }
                                                do {
                                                    
                                                    let photoDecoder = JSONDecoder()
                                                    
                                                    var photoCall = try photoDecoder.decode(photoData.self, from: data)
                                                    print(photoCall.D.Results)
                                                } catch let err {
                                                    print(err)
                                                }
                                            }
                                            photoTask.resume()

                                        }


//                                        print("This is + \(theCall.D.Results)\n")
                        
                        
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

