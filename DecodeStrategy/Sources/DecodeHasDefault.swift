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
        
        do {
            wrappedValue = try container.decode(Provoder.Value.self)
        } catch {
            DecodeStrategy.errorDelegate?.onCatch(error: error)
            wrappedValue = Provoder.defaultValue
        }
    }
}

public extension KeyedDecodingContainer {
    
    /// If KeyNotFound, use default value
    func decode<Provoder>(_ type: DecodeHasDefault<Provoder>.Type, forKey key: Key) throws
        -> DecodeHasDefault<Provoder>
    {
        
        let defaultValue: () -> DecodeHasDefault<Provoder> = {
            DecodeHasDefault(wrappedValue: Provoder.defaultValue)
        }
        
        do {
            return try decodeIfPresent(type.self, forKey: key) ?? defaultValue()
        } catch {
            DecodeStrategy.errorDelegate?.onCatch(error: error)
            return defaultValue()
        }
    }
}
