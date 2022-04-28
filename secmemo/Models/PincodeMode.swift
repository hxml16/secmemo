//
//  PincodeMode.swift
//  secmemo
//
//  Created by heximal on 11.02.2022.
//

import Foundation

enum PincodeMode {
    case none
    case unlock
    case setupSecurity
    case setupEmergency
    case repeatSecurity
    case repeatEmergency
    case changeSecurity
    case changeEmergency
}

extension PincodeMode {
    var lzTitleCode: String {
        switch self {
            case .setupSecurity:
                return "pinCode.setupSecurityPincodeTitle"
            case .setupEmergency:
                return  "pinCode.setupEmergencyPincodeTitle"
            case .repeatSecurity:
                return  "pinCode.repeatSecurityPincodeTitle"
            case .repeatEmergency:
                return  "pinCode.repeatEmergencyPincodeTitle"
            case .unlock:
                return "pinCode.unlockTitle"
            case .changeSecurity:
                return "pinCode.changeSecurityPincodeTitle"
            case .changeEmergency:
                return "pinCode.changeEmergencyPincodeTitle"
            case .none:
                return ""
        }
    }
    
    var isChangeMode: Bool {
        return self == .changeSecurity || self == .changeEmergency
    }
}
