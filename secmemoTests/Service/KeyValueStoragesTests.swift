//
//  KeyValueStoragesTests.swift
//  secmemoTests
//
//  Created by heximal on 10.02.2022.
//

import XCTest
@testable import secmemo

class KeyValueStoragesTests: XCTestCase {
    let testStringKey = "testStringKey"
    let testBoolKey = "testBoolKey"
    let testIntKey = "testIntKey"
    let testFloatKey = "testFloatKey"

    let testStringValue = "Hello World"
    let testBoolValue = true
    let testIntValue = 16
    let testFloatValue: Float = 16.0
    
    func testKeychainStorage() throws {
        let keyChainStorage = KeyChainStorage()
        checkStorage(storage: keyChainStorage)
    }
    
    func testUserDefaultsStorage() throws {
        let userDefaultsStorage = UserDefaultsStorage()
        checkStorage(storage: userDefaultsStorage)
    }

    private func checkStorage(storage: KeyValueStorage) {
        // Checks storing values in specified storage
        storage.set(value: testStringValue, forKey: testStringKey)
        storage.set(value: testBoolValue, forKey: testBoolKey)
        storage.set(value: testIntValue, forKey: testIntKey)
        storage.set(value: testFloatValue, forKey: testFloatKey)
        
        XCTAssertEqual(storage.string(forKey: testStringKey), testStringValue)
        XCTAssertEqual(storage.bool(forKey: testBoolKey), testBoolValue)
        XCTAssertEqual(storage.int(forKey: testIntKey), testIntValue)
        XCTAssertEqual(storage.float(forKey: testFloatKey), testFloatValue)
        
        // Checks deletion from specified storage
        storage.remove(forKey: testStringKey)
        storage.remove(forKey: testBoolKey)
        storage.remove(forKey: testIntKey)
        storage.remove(forKey: testFloatKey)
        
        XCTAssertNil(storage.string(forKey: testStringKey))
        XCTAssertNil(storage.string(forKey: testBoolKey))
        XCTAssertNil(storage.string(forKey: testIntKey))
        XCTAssertNil(storage.string(forKey: testFloatKey))
    }
}
