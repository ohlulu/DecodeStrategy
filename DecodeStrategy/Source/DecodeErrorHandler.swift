//
//  DecodeStrategy.swift
//  DecodeStrategy
//
//  Created by Ohlulu on 2020/7/16.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import Foundation

public protocol DecodeErrorDelegate {
    
    func onCatch(error: Error)
}

public struct DecodeStrategy {
    
    public static var errorDelegate: DecodeErrorDelegate?
}
