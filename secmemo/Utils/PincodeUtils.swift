//
//  PincodeUtils.swift
//  secmemo
//
//  Created by heximal on 07.04.2022.
//

import Foundation

class PincodeUtils {
    static func isPincodeValid(_ pincode: String?) -> Bool {
        guard let pincode = pincode else {
            return false
        }
        return pincode.count == GlobalConstants.pincodeLength
    }
}
