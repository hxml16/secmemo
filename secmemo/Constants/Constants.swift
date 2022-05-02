//
//  Constants.swift
//  secmemo
//
//  Created by heximal on 13.03.2022.
//

import Foundation
import UIKit

enum GlobalConstants {
    static let imageEntryThumbnailSize = CGSize(width: 128, height: 128)
    static let pincodeLength: Int = 4
    static let opaqueAlphaValue: CGFloat = 1.0
    static let semitransparentAlphaValue: CGFloat = 0.5
    static let unlockAttemptsCountUntilBlock: Int = 4
    static let blockTimerSecondsValue: TimeInterval = 5 * 60 // 5 minutes
}
