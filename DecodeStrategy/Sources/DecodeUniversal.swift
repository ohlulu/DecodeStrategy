//
//  DecodeUniversal.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeUniversal<Value: LosslessStringConvertible & Decodable>: Decodable {
    
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
