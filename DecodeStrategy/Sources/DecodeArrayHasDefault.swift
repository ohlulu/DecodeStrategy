//
//  DecodeArrayHasDefault.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeArrayHasDefault<Provider: DecodeDefaultProvider>: Decodable {
    
    public var wrappedValue: [Provider.Value]
    
    public init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        var result = [Provider.Value]()
        var errors = [Error]()
        
        while !container.isAtEnd {
            do {
                let element = try container.decode(Provider.Value.self)
                result.append(element)
            } catch {
                _ = try container.decode(AnyDecodable.self)
                result.append(Provider.defaultValue)
                errors.append(error)
            }
        }
        
        if let delegate = DecodeStrategy.errorDelegate {
            errors.forEach { delegate.onCatch(error: $0) }
        }
        
        wrappedValue = result
    }
}
