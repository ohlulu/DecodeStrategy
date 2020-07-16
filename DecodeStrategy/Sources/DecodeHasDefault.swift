//
//  DecodeHasDefault.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/13.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeHasDefault<Provider: DecodeDefaultProvider>: Decodable {
    
    public var wrappedValue: Provider.Value
    
    public init(wrappedValue: Provider.Value) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        do {
            wrappedValue = try container.decode(Provider.Value.self)
        } catch {
            DecodeStrategy.errorDelegate?.onCatch(error: error)
            wrappedValue = Provider.defaultValue
        }
    }
}

public extension KeyedDecodingContainer {
    
    /// If KeyNotFound, use default value
    func decode<Provider>(_ type: DecodeHasDefault<Provider>.Type, forKey key: Key) throws
        -> DecodeHasDefault<Provider>
    {
        
        let defaultValue: () -> DecodeHasDefault<Provider> = {
            DecodeHasDefault(wrappedValue: Provider.defaultValue)
        }
        
        do {
            return try decodeIfPresent(type.self, forKey: key) ?? defaultValue()
        } catch {
            DecodeStrategy.errorDelegate?.onCatch(error: error)
            return defaultValue()
        }
    }
}
