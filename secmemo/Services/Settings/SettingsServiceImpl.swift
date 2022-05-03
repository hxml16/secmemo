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

    var pincodeUnlockAttemptsCount: Int {
        get {
            if let i = userDefaultsStorage.int(forKey: SettingsConstants.pincodeUnlockAttemptsCount.rawValue) {
                return i
            }
            return -1
        }
        
        set {
            userDefaultsStorage.set(value: newValue, forKey: SettingsConstants.pincodeUnlockAttemptsCount.rawValue)
        }
    }
    
    var pincodeWrongAttemptsCount: Int {
        get {
            if let i = userDefaultsStorage.int(forKey: SettingsConstants.pincodeWrongAttemptsCount.rawValue) {
                return i
            }
            return -1
        }
        
        set {
            userDefaultsStorage.set(value: newValue, forKey: SettingsConstants.pincodeWrongAttemptsCount.rawValue)
        }
    }
    
    var numberOfWrongPincodeAttempts: Int {
        get {
            if let i = userDefaultsStorage.int(forKey: SettingsConstants.numberOfWrongPincodeAttempts.rawValue) {
                return i
            }
            return -1
        }
        
        set {
            userDefaultsStorage.set(value: newValue, forKey: SettingsConstants.numberOfWrongPincodeAttempts.rawValue)
        }
    }
    
    func restoreUnlockAttemptsCount() {
        pincodeUnlockAttemptsCount = GlobalConstants.unlockAttemptsCountUntilBlock
    }
    
    func restoreWrongUnlockAttemptsCount() {
        pincodeWrongAttemptsCount = numberOfWrongPincodeAttempts
    }
    
    var pincodeBlockedUntil: TimeInterval {
        get {
            if let d = userDefaultsStorage.double(forKey: SettingsConstants.pincodeBlockedUntil.rawValue) {
                return TimeInterval(d)
            }
            return 0
        }
        
        set {
            userDefaultsStorage.set(value: Double(newValue), forKey: SettingsConstants.pincodeBlockedUntil.rawValue)
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
