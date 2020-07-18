//
//  DecodeUniversal_Test.swift
//  DecodeStrategyTests
//
//  Created by Ohlulu on 2020/7/15.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import XCTest
import DecodeStrategy

class DecodeUniversal_Test: XCTestCase {
    
    let decoder = JSONDecoder()
    
    struct SuccessModel: Decodable {
        @DecodeUniversal var strValue: String
        @DecodeUniversal var intValue: Int
        @DecodeUniversal var doubleValue: Double
    }
    
    func test_success() {
        let successData = """
        {
            "strValue": "str",
            "intValue": 100,
            "doubleValue": 1.1
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(SuccessModel.self, from: successData)
            XCTAssertEqual(model.strValue, "str")
            XCTAssertEqual(model.intValue, 100)
            XCTAssertEqual(model.doubleValue, 1.1)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    struct StringFailureModel: Decodable {
        @DecodeUniversal var strValue: String
        @DecodeUniversal var intValue: String
        @DecodeUniversal var doubleValue: String
    }
    
    func test_string_failureOfTyp() {
        let failureOfTypeData1 = """
        {
            "strValue": "+100.1",
            "intValue": 100,
            "doubleValue": 100.1
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(StringFailureModel.self, from: failureOfTypeData1)
            XCTAssertEqual(model.strValue, "+100.1")
            XCTAssertEqual(model.intValue, "100")
            XCTAssertEqual(model.doubleValue, "100.1")
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    struct IntFailureModel: Decodable {
        @DecodeUniversal var strValue: Int
        @DecodeUniversal var intValue: Int
        @DecodeUniversal var doubleValue: Int
    }
    
    func test_int_failureOfType() {
        
        let failureOfTypeData2 = """
        {
            "strValue": "+100",
            "intValue": 100,
            "doubleValue": 100.1
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(IntFailureModel.self, from: failureOfTypeData2)
            XCTAssertEqual(model.strValue, 100)
            XCTAssertEqual(model.intValue, 100)
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                XCTAssertEqual(context.codingPath.first?.stringValue, "doubleValue")
            default:
                XCTFail("should not error : \(error)")
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    struct DoubleFailureModel: Decodable {
        @DecodeUniversal var strValue: Double
        @DecodeUniversal var intValue: Double
        @DecodeUniversal var doubleValue: Double
    }
    
    func test_double_failureOfType() {
        let failureOfTypeData = """
        {
            "strValue": "100.1",
            "intValue": 100,
            "doubleValue": 100.1
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(DoubleFailureModel.self, from: failureOfTypeData)
            XCTAssertEqual(model.strValue, 100.1)
            XCTAssertEqual(model.intValue, 100.0)
            XCTAssertEqual(model.doubleValue, 100.1)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
}
