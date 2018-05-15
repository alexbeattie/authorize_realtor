//
//  Auth.swift
//  newcall
//
//  Created by Alex Beattie on 5/10/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import Foundation

import UIKit


class Listing:  Decodable, Encodable {
    var listPrice: Int?
    var photos: [String]?
    var address: Address?
    var mlsId: Int!
    var listingId: String?
    var property: Property?
    var geo: Geo?
    var remarks: String?
    var virtualTourUrl: String?
    
    struct Address: Decodable, Encodable {
        var full: String?
    }
    
    struct Property: Decodable, Encodable {
        var bathsFull: Int?
        var bathsHalf: Int?
        var bedrooms: Int?
    }
    struct Geo: Decodable, Encodable {
        var lat: Double?
        var lng: Double?
    }
    
    
    
    
    
    static func fetchListing(_ completionHandler: @escaping ([Listing]) -> ()) {
        //        let baseUrl = URL(string: "http://localhost:8888/simplyrets/file.js")
        let baseUrl = URL(string: "http://artisanbranding.s3.amazonaws.com/file.js?sort=-listprice")
        //        let baseUrl = URL(string: "https://simplyrets:simplyrets@api.simplyrets.com/properties?limit=50&offset=3&sort=-listprice&count=false")
        let task = URLSession.shared.dataTask(with: baseUrl!) { (data, response, error) in
            
            guard let data = data else { return }
            if let error = error {
                print(error)
            }
            
            do {
                
                let decoder = JSONDecoder()
                let listing = try decoder.decode([Listing].self, from: data)
                //                print(listing)
                //
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(listing)
                    print(listing)
                    
                })
            } catch let err {
                print(err)
            }
            
        }
        task.resume()
    }
}
