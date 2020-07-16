//
//  DefaultValueProvoder.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/14.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

public protocol DecodeDefaultProvoder {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

public struct EmptyString: DecodeDefaultProvoder {
    public static var defaultValue: String = ""
}

public struct ZeroInt: DecodeDefaultProvoder {
    public static var defaultValue: Int = 0
}

public struct ZeroDouble: DecodeDefaultProvoder {
    public static var defaultValue: Double = 0.0
}
