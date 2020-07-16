//
//  DecodeArrayIgnore.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeArrayIgnore<Value: Decodable>: Decodable {
    
    public var wrappedValue: [Value]
    
    public init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        var result = [Value]()
        
        while !container.isAtEnd {
            if let element = try? container.decode(Value.self) {
                result.append(element)
            } else {
                _ = try container.decode(AnyDecodable.self)
            }
        }
        
        wrappedValue = result
    }
}
