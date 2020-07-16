//
//  DecodeArrayHasDefault_Test.swift
//  DecodeStrategyTests
//
//  Created by Ohlulu on 2020/7/15.
//  Copyright © 2020 Ohlulu. All rights reserved.
//

import XCTest
import DecodeStrategy

struct UserList_HasDefault: Decodable {
    
    struct UserInfoDefault: DecodeDefaultProvider {
        static var defaultValue = UserList_HasDefault.UserInfo()
    }
    
    struct UserInfo: Decodable {
        let name: String
        let age: Int
        init() {
            name = "Ohlulu"
            age = 18
        }
    }
    
    @DecodeArrayHasDefault<UserInfoDefault>
    var userList: [UserInfo]
}


class DecodeArrayHasDefault_Test: XCTestCase {
    
    let decoder = JSONDecoder()
    
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
            let model = try decoder.decode(UserList_HasDefault.self, from: successData)
            XCTAssertEqual(model.userList.count, 2)
            for user in model.userList {
                XCTAssertEqual(user.name, "xxx")
                XCTAssertEqual(user.age, 28)
            }
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_failureOfType() {
        let fauilureOfKeyNotFoundData = """
        {
            "userList": [
                {
                    "name": 18,
                    "age": "Ohlulu"
                },
                {
                    "name": "xxx",
                    "age": 28
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(UserList_HasDefault.self, from: fauilureOfKeyNotFoundData)
            XCTAssertEqual(model.userList.count, 2)
            XCTAssertEqual(model.userList[0].name, "Ohlulu")
            XCTAssertEqual(model.userList[0].age, 18)
            
            XCTAssertEqual(model.userList[1].name, "xxx")
            XCTAssertEqual(model.userList[1].age, 28)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
    
    func test_failureOfKeyNotFound() {
        let fauilureOfKeyNotFoundData = """
        {
            "userList": [
                {
                    "name1": "xxx",
                    "age1": "10"
                },
                {
                    "name": "xxx",
                    "age": 28
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let model = try decoder.decode(UserList_HasDefault.self, from: fauilureOfKeyNotFoundData)
            XCTAssertEqual(model.userList.count, 2)
            XCTAssertEqual(model.userList[0].name, "Ohlulu")
            XCTAssertEqual(model.userList[0].age, 18)
            
            XCTAssertEqual(model.userList[1].name, "xxx")
            XCTAssertEqual(model.userList[1].age, 28)
        } catch {
            XCTFail("should not error : \(error)")
        }
    }
}
