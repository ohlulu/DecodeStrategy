//
//  DefaultValueProvider.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

public protocol DecodeDefaultProvider {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

public struct EmptyString: DecodeDefaultProvider {
    public static var defaultValue: String = ""
}

public struct ZeroInt: DecodeDefaultProvider {
    public static var defaultValue: Int = 0
}

public struct ZeroDouble: DecodeDefaultProvider {
    public static var defaultValue: Double = 0.0
}
