//
//  KeyValueStorageMock.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation
@testable import secmemo

class KeyValueStorageMock: KeyValueStorage {
    func double(forKey: String) -> Double? {
        dict[forKey] as? Double
    }
    
    func set(value: Double?, forKey: String) {
        dict[forKey] = value as AnyObject?
    }
    
    var dict: [String: AnyObject] = [:]
    
    func remove(forKey: String) {
        dict[forKey] = nil
    }

    func set(value: AnyObject?, forKey: String) {
        dict[forKey] = value
    }
    
    func value(forKey: String) -> AnyObject? {
        return dict[forKey]
    }
    
    func int(forKey: String) -> Int? {
        return value(forKey: forKey) as? Int
    }
    
    func set(value: Int?, forKey: String) {
        dict[forKey] = value as AnyObject?
    }
    
    func float(forKey: String) -> Float? {
        return dict[forKey] as? Float
    }
    
    func set(value: Float?, forKey: String) {
        dict[forKey] = value as AnyObject?
    }
    
    func string(forKey: String) -> String? {
        return dict[forKey] as? String
    }
    
    func set(value: String?, forKey: String) {
        dict[forKey] = value as AnyObject?
    }
    
    func bool(forKey: String) -> Bool? {
        return dict[forKey] as? Bool
    }
    
    func set(value: Bool?, forKey: String) {
        dict[forKey] = value as AnyObject?
    }
}
