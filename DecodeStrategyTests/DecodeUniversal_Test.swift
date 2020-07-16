//
//  DecodeUniversal_Test.swift
//  DecodeStrategyTests
//
//  Created by Ohlulu on 2020/7/15.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import XCTest
import DecodeStrategy

struct StringAndNumbersModel: Decodable {
    @DecodeUniversal var strValue: String
    @DecodeUniversal var intValue: Int
    @DecodeUniversal var doubleValue: Double
}

class DecodeUniversal_Test: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func test_success() {
        let successData = """
        {
            "strValue": "str",
            "intValue": 100,
            "doubleValue": 1.1
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(StringAndNumbersModel.self, from: successData)
            XCTAssertEqual(model.strValue, "str")
            XCTAssertEqual(model.intValue, 100)
            XCTAssertEqual(model.doubleValue, 1.1)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_failureOfTyp() {
        let failureOfTypeData1 = """
        {
            "strValue": 100,
            "intValue": "+200",
            "doubleValue": "300.1"
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(StringAndNumbersModel.self, from: failureOfTypeData1)
            XCTAssertEqual(model.strValue, "100")
            XCTAssertEqual(model.intValue, 200)
            XCTAssertEqual(model.doubleValue, 300.1)
        } catch {
            XCTFail("should not error : \(error)")
        }
        
        let failureOfTypeData2 = """
        {
            "strValue": 100,
            "intValue": 2000.0,
            "doubleValue": 300
        }
        """.data(using: .utf8)!
        do {
            let model = try decoder.decode(StringAndNumbersModel.self, from: failureOfTypeData2)
            XCTAssertEqual(model.strValue, "100")
            XCTAssertEqual(model.intValue, 2000)
            XCTAssertEqual(model.doubleValue, 300.0)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_failureOfKeyNotFound() {
        let failureOfTypeData = """
        {
            "strValue1": 100,
            "intValue1": "+200",
            "doubleValue1": "300.1"
        }
        """.data(using: .utf8)!
        do {
            let _ = try decoder.decode(StringAndNumbersModel.self, from: failureOfTypeData)
            XCTFail("should not success")
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(_, _):
                XCTAssert(true)
            default:
                XCTFail("should not error : \(error)")
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
}
