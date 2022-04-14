//
//  KeychainStorage.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation
import SwiftKeychainWrapper

class KeyChainStorage: KeyValueStorage {
    func remove(forKey: String) {
        KeychainWrapper.standard.removeObject(forKey:forKey)
    }

    func set(value: AnyObject?, forKey: String) {
    }
    
    func value(forKey: String) -> AnyObject? {
        return KeychainWrapper.standard.object(forKey: forKey)
    }
    
    func int(forKey: String) -> Int? {
        return KeychainWrapper.standard.integer(forKey: forKey)
    }
    
    func set(value: Int?, forKey: String) {
        if let value = value {
            KeychainWrapper.standard.set(value, forKey: forKey)
        } else {
            KeychainWrapper.standard.removeObject(forKey: forKey)
        }
    }
    
    func float(forKey: String) -> Float? {
        return KeychainWrapper.standard.float(forKey: forKey)
    }
    
    func set(value: Float?, forKey: String) {
        if let value = value {
            KeychainWrapper.standard.set(value, forKey: forKey)
        } else {
            KeychainWrapper.standard.removeObject(forKey: forKey)
        }
    }
    
    func string(forKey: String) -> String? {
        return KeychainWrapper.standard.string(forKey: forKey)
    }
    
    func set(value: String?, forKey: String){
        if let value = value {
            KeychainWrapper.standard.set(value, forKey: forKey)
        } else {
            KeychainWrapper.standard.removeObject(forKey: forKey)
        }
    }
    
    func bool(forKey: String) -> Bool?{
        return KeychainWrapper.standard.bool(forKey: forKey)
    }
    
    func set(value: Bool?, forKey: String){
        if let value = value {
            KeychainWrapper.standard.set(value, forKey: forKey)
        } else {
            KeychainWrapper.standard.removeObject(forKey: forKey)
        }
    }
}
