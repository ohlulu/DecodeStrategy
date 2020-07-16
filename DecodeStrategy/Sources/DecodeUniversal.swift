//
//  DecodeUniversal.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

public typealias LosslessAndDecodable = LosslessStringConvertible & Decodable

@propertyWrapper
public struct DecodeUniversal<Value: LosslessAndDecodable>: Decodable {
    
    public var wrappedValue: Value
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        do {
            wrappedValue = try container.decode(Value.self)
        } catch {
            
            DecodeStrategy.errorDelegate?.onCatch(error: error)
            
            let temp: String
            if let strValue = try? container.decode(String.self) {
                temp = strValue
            } else if let intValue = try? container.decode(Int.self) {
                temp = "\(intValue)"
            } else if let doubleValue = try? container.decode(Double.self) {
                temp = "\(doubleValue)"
            } else {
                throw error
            }
            
            if let value = Value.init(temp) {
                wrappedValue = value
            } else {
                throw error
            }
        }
    }
}

/*
@propertyWrapper
public struct DecodeUniversal2<Value: LosslessAndDecodable>: Decodable {
    
    public var wrappedValue: Value
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        do {
            
            wrappedValue = try container.decode(Value.self)
            
        } catch {
            
            typealias Closure = (SingleValueDecodingContainer) -> LosslessStringConvertible?
            
            func tryDecode<T: LosslessAndDecodable>(_ type: T.Type) -> Closure {
                return { try? $0.decode(T.self) }
            }
            
            let typeDecoders: [Closure] = [
                tryDecode(String.self),
                tryDecode(Int.self),
                tryDecode(Double.self)
            ]
            
            guard
                let losslessValue = typeDecoders.lazy.compactMap({ $0(container) }).first,
                let value = Value.init("\(losslessValue)")
            else {
                throw error
            }
            
            wrappedValue = value
        }
    }
}
*/
