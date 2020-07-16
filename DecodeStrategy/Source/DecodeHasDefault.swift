//
//  DecodeHasDefault.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/13.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeHasDefault<Provoder: DecodeDefaultProvoder>: Decodable {
    
    public var wrappedValue: Provoder.Value
    
    public init(wrappedValue: Provoder.Value) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        wrappedValue = (try? container.decode(Provoder.Value.self)) ?? Provoder.defaultValue
    }
}

public extension KeyedDecodingContainer {
    
    /// If KeyNotFound, use default value
    func decode<Provoder>(_ type: DecodeHasDefault<Provoder>.Type, forKey key: Key) throws
        -> DecodeHasDefault<Provoder>
    {
        if let value = try? decodeIfPresent(type.self, forKey: key) {
            return value
        } else {
            return DecodeHasDefault(wrappedValue: Provoder.defaultValue)
        }
    }
}
