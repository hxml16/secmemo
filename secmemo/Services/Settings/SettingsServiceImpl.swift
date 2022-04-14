//
//  SettingsServiceImpl.swift
//  secmemo
//
//  Created by heximal on 06.04.2022.
//

import Foundation

class SettingsServiceImpl: SettingsService {
    private var userDefaultsStorage: KeyValueStorage
    private var keyChainStorage: KeyValueStorage

    init(userDefaultsStorage: UserDefaultsStorage, keyChainStorage: KeyChainStorage) {
        self.userDefaultsStorage = userDefaultsStorage
        self.keyChainStorage = keyChainStorage
    }
    
    // Alternative constructor for Unit testing
    init(userDefaultsStorage: KeyValueStorage, keyChainStorage: KeyValueStorage) {
        self.userDefaultsStorage = userDefaultsStorage
        self.keyChainStorage = keyChainStorage
    }

    var pincodesCreated: Bool {
        get {
            if let b = userDefaultsStorage.bool(forKey: SettingsConstants.pincodesCreated.rawValue) {
                return b
            }
            return false
        }
        
        set {
            userDefaultsStorage.set(value: true, forKey: SettingsConstants.pincodesCreated.rawValue)
        }
    }
    
    var securityPincodeEnabled: Bool {
        get {
            if let b = userDefaultsStorage.bool(forKey: SettingsConstants.securityPincodeEnabled.rawValue) {
                return b
            }
            return false
        }
        
        set {
            userDefaultsStorage.set(value: newValue, forKey: SettingsConstants.securityPincodeEnabled.rawValue)
        }
    }
    
    var emergencyPincodeEnabled: Bool {
        get {
            if let b = userDefaultsStorage.bool(forKey: SettingsConstants.emergencyPincodeEnabled.rawValue) {
                return b
            }
            return false
        }
        
        set {
            userDefaultsStorage.set(value: newValue, forKey: SettingsConstants.emergencyPincodeEnabled.rawValue)
        }
    }

    
    var securityPincode: String? {
        get {
            return keyChainStorage.string(forKey: SettingsConstants.securityPincode.rawValue)
        }

        set {
            keyChainStorage.set(value: newValue, forKey: SettingsConstants.securityPincode.rawValue)
        }
    }

    var emergencyPincode: String? {
        get {
            return keyChainStorage.string(forKey: SettingsConstants.emergencyPincode.rawValue)
        }

        set {
            keyChainStorage.set(value: newValue, forKey: SettingsConstants.emergencyPincode.rawValue)
        }
    }
}
