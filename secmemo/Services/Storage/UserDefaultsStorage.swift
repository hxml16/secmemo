//
//  UserDefaultsStorage.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation

class UserDefaultsStorage: KeyValueStorage {
    let userDefaults = UserDefaults.standard
    
    func remove(forKey: String) {
        userDefaults.removeObject(forKey: forKey)
    }

    func set(value: AnyObject?, forKey: String) {
    }
    
    func value(forKey: String) -> AnyObject? {
        return userDefaults.object(forKey: forKey) as AnyObject
    }
    
    func int(forKey: String) -> Int? {
        return userDefaults.integer(forKey: forKey)
    }
    
    func set(value: Int?, forKey: String) {
        if let value = value {
            userDefaults.set(value, forKey: forKey)
        } else {
            userDefaults.removeObject(forKey: forKey)
        }
        synchronize()
    }
    
    func float(forKey: String) -> Float? {
        return userDefaults.float(forKey: forKey)
    }
    
    func set(value: Float?, forKey: String) {
        if let value = value {
            userDefaults.set(value, forKey: forKey)
        } else {
            userDefaults.removeObject(forKey: forKey)
        }
        synchronize()
    }
    
    func double(forKey: String) -> Double? {
        return userDefaults.double(forKey: forKey)
    }
    
    func set(value: Double?, forKey: String) {
        if let value = value {
            userDefaults.set(value, forKey: forKey)
        } else {
            userDefaults.removeObject(forKey: forKey)
        }
        synchronize()
    }
    
    func string(forKey: String) -> String? {
        return userDefaults.string(forKey: forKey)
    }
    
    func set(value: String?, forKey: String) {
        if let value = value {
            userDefaults.set(value, forKey: forKey)
        } else {
            userDefaults.removeObject(forKey: forKey)
        }
        synchronize()
    }
    
    func bool(forKey: String) -> Bool? {
        return userDefaults.bool(forKey: forKey)
    }
    
    func set(value: Bool?, forKey: String) {
        if let value = value {
            userDefaults.set(value, forKey: forKey)
        } else {
            userDefaults.removeObject(forKey: forKey)
        }
        synchronize()
    }
    
    private func synchronize() {
        userDefaults.synchronize()
    }
}
