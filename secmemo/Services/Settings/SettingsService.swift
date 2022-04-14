//
//  SettingsService.swift
//  secmemo
//
//  Created by heximal on 06.04.2022.
//

import Foundation

protocol SettingsService {
    var pincodesCreated: Bool { get set }
    var securityPincodeEnabled: Bool { get set }
    var emergencyPincodeEnabled: Bool { get set }
    var securityPincode: String? { get set }
    var emergencyPincode: String? { get set }
}
