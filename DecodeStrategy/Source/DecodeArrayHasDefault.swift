//
//  DecodeArrayHasDefault.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeArrayHasDefault<Provoder: DecodeDefaultProvoder>: Decodable {
    
    public var wrappedValue: [Provoder.Value]
    
    public init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        var result = [Provoder.Value]()
        
        while !container.isAtEnd {
            if let element = try? container.decode(Provoder.Value.self) {
                result.append(element)
            } else {
                _ = try container.decode(AnyDecodable.self)
                result.append(Provoder.defaultValue)
            }
        }
        
        wrappedValue = result
    }
}
