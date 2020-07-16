//
//  DecodeHasDefault_Test.swift
//  DecodeStrategyTests
//
//  Created by Ohlulu on 2020/7/15.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import XCTest
import DecodeStrategy

class DecodeHasDefault_Test: XCTestCase {
    
    let decoder = JSONDecoder()
    
    struct User: Decodable {
        struct NameDefault: DecodeDefaultProvoder {
            static var defaultValue: String = "ohlulu"
        }
        
        @DecodeHasDefault<NameDefault>
        var name: String
        
        struct AgeDefault: DecodeDefaultProvoder {
            static var defaultValue: Int = 18
        }
        
        @DecodeHasDefault<AgeDefault>
        var age: Int
    }
    
    func test_success() {
        let name = "John"
        let age = 28
        
        let successData = """
        {
            "name": "\(name)",
            "age": \(age)
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(User.self, from: successData)
            XCTAssertEqual(model.name, name)
            XCTAssertEqual(model.age, age)
        } catch {
            XCTFail("should not error : \(error.localizedDescription)")
        }
    }
    
    func test_failureOfType() {
        let failureOfTypeData = """
        {
            "name": 18,
            "age": "xxx"
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(User.self, from: failureOfTypeData)
            XCTAssertEqual(model.name, User.NameDefault.defaultValue)
            XCTAssertEqual(model.age, User.AgeDefault.defaultValue)
        } catch {
            XCTFail("should not error : \(error.localizedDescription)")
        }
    }
    
    func test_failureOfKeyNotFound() {
        
        let failureOfKeyData = """
        {
            "name1": "xxx",
            "age1": 28
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(User.self, from: failureOfKeyData)
            XCTAssertEqual(model.name, User.NameDefault.defaultValue)
            XCTAssertEqual(model.age, User.AgeDefault.defaultValue)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    struct UseDefaultEmpty: Decodable {
        @DecodeHasDefault<EmptyString> var strValue: String
        @DecodeHasDefault<ZeroInt> var intValue: Int
        @DecodeHasDefault<ZeroDouble> var doubleValue: Double
    }
    
    func test_defaultProvoder() {
        let data = """
        {
            "strValue": 123,
            "intValue": "123",
            "doubleValue": "12.12"
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(UseDefaultEmpty.self, from: data)
            XCTAssertEqual(model.strValue, "")
            XCTAssertEqual(model.intValue, 0)
            XCTAssertEqual(model.doubleValue, 0.0)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
}
