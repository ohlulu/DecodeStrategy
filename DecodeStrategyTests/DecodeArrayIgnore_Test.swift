//
//  DecodeArrayIgnore_Test.swift
//  DecodeStrategyTests
//
//  Created by Ohlulu on 2020/7/15.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import XCTest
import DecodeStrategy

class DecodeArrayIgnore_Test: XCTestCase {
    
    let decoder = JSONDecoder()
    
    struct UserList: Decodable {
        
        struct UserInfo: Decodable {
            let name: String
            let age: Int
        }
        
        @DecodeArrayIgnore
        var userList: [UserInfo]
    }
    
    func test_success() {
        
        let successData = """
        {
            "userList": [
                {
                    "name": "xxx",
                    "age": 28
                },
                {
                    "name": "xxx",
                    "age": 28
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(UserList.self, from: successData)
            XCTAssertEqual(model.userList.count, 2)
            for user in model.userList {
                XCTAssertEqual(user.name, "xxx")
                XCTAssertEqual(user.age, 28)
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_ailureOfType() {
        
        let failureOfTypeData = """
        {
            "userList": [
                {
                    "name": 10,
                    "age": 28
                },
                {
                    "name": "xxx",
                    "age": 28
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(UserList.self, from: failureOfTypeData)
            XCTAssertEqual(model.userList.count, 1)
            for user in model.userList {
                XCTAssertEqual(user.name, "xxx")
                XCTAssertEqual(user.age, 28)
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_failureOfKeyNotFound() {
        let failureOfKeyNotFoundData = """
        {
            "userList": [
                {
                    "name": "xxx",
                    "age2": 28
                },
                {
                    "name": "xxx",
                    "age": 28
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(UserList.self, from: failureOfKeyNotFoundData)
            XCTAssertEqual(model.userList.count, 1)
            for user in model.userList {
                XCTAssertEqual(user.name, "xxx")
                XCTAssertEqual(user.age, 28)
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
}
