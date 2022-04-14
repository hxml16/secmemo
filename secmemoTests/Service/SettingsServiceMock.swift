//
//  SettingsServiceMock.swift
//  secmemoTests
//
//  Created by heximal on 06.04.2022.
//

import Foundation
@testable import secmemo

class SettingsServiceMock: SettingsService {
    var settings: [String: AnyObject] = [:]
    
    var pincodesCreated: Bool {
        get {
            if let b = settings[SettingsConstants.pincodesCreated.rawValue] as? Bool {
                return b
            }
            return false
        }
        
        set {
            settings[SettingsConstants.pincodesCreated.rawValue] = newValue as AnyObject
        }
    }
    
    var securityPincodeEnabled: Bool {
        get {
            if let b = settings[SettingsConstants.securityPincodeEnabled.rawValue] as? Bool {
                return b
            }
            return false
        }
        
        set {
            settings[SettingsConstants.securityPincodeEnabled.rawValue] = newValue as AnyObject?
        }
    }
    
    var emergencyPincodeEnabled: Bool {
        get {
            if let b = settings[SettingsConstants.emergencyPincodeEnabled.rawValue] as? Bool {
                return b
            }
            return false
        }
        
        set {
            settings[SettingsConstants.emergencyPincodeEnabled.rawValue] = newValue as AnyObject?
        }
    }

    var securityPincode: String? {
        get {
            if let b = settings[SettingsConstants.securityPincode.rawValue] as? String {
                return b
            }
            return nil
        }
        
        set {
            settings[SettingsConstants.securityPincode.rawValue] = newValue as AnyObject?
        }
    }

    var emergencyPincode: String? {
        get {
            if let b = settings[SettingsConstants.emergencyPincode.rawValue] as? String {
                return b
            }
            return nil
        }
        
        set {
            settings[SettingsConstants.emergencyPincode.rawValue] = newValue as AnyObject?
        }
    }
}
