//
//  Error.swift
//  secmemo
//
//  Created by heximal on 07.03.2022.
//

import Foundation

enum Errors: Int {
    case unknown = -1000
    case initStorageFailed = -1001
    case memoStorageFailed = -1002
    case locationServiceUnavailable = -1003
    case locationInvalid = -1004
    
    var error: Error {
        var descriptionLzCode = "error.unknown"
        switch self {
            case .initStorageFailed:
                descriptionLzCode = "error.initStorageFailed"
            case .memoStorageFailed:
                descriptionLzCode = "error.memoStorageFailed"
            case .locationServiceUnavailable:
                descriptionLzCode = "error.locationServiceUnavailable"
            case .locationInvalid:
                descriptionLzCode = "error.locationInvalid"
            default:
                break
        }
        let error = NSError(domain: "", code: self.rawValue, userInfo: [NSLocalizedDescriptionKey: descriptionLzCode.localized])
        return error as Error
    }
}
