//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 12/8/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

enum ElementModelParseError: Error {
    case results, parsing
}

class Element {
    let name:       String
    let symbol:     String
    let number:     Int
    let weight:     Double
    let melting:    Int //    "melting_c": -259,
    let boiling:    Int //    "boiling_c": -253,
    let image:      String
    let thumb:      String
    
    init(
        name:       String,
        symbol:     String,
        number:     Int,
        weight:     Double,
        melting:    Int,
        boiling:    Int,
        image:      String,
        thumb:      String
        ) {
        self.name = name
        self.symbol = symbol
        self.number = number
        self.weight = weight
        self.melting = melting
        self.boiling = boiling
        self.image = image
        self.thumb = thumb
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        guard let name = dictionary["name"] as? String,
            let symbol = dictionary["symbol"] as? String,
            let number = dictionary["number"] as? Int,
            let weight = dictionary["weight"] as? Double else { throw ElementModelParseError.parsing }
        
        var meltPoint = -9000
        if let melting = dictionary["melting_c"] as? Int {
            meltPoint = melting
        }
        
        var boilPoint = 9000
        if let boiling = dictionary["boiling_c"] as? Int {
            boilPoint = boiling
        }
        
        let imageURLChunk = "https://s3.amazonaws.com/ac3.2-elements/"
        
        self.init(name:       name,
                  symbol:     symbol,
                  number:     number,
                  weight:     weight,
                  melting:    meltPoint,
                  boiling:    boilPoint,
                  image: "\(imageURLChunk)\(symbol).png",
                  thumb: "\(imageURLChunk)\(symbol)_200.png")
    }
    
    static func elements(from data: Data) -> [Element]? {
        var elementToReturn: [Element]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [[String : AnyObject]] else {
                throw ElementModelParseError.results
            }
            
            for elementDict in response {
                if let element = try Element(from: elementDict) {
                    elementToReturn?.append(element)
                }
            }
        }
        catch {
            print("Error encountered with \(error)")
        }
        
        return elementToReturn
    }
}
