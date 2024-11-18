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
    static let defaultAutoLockTimeout: Int = 60 // 1 minute
    static let opaqueAlphaValue: CGFloat = 1.0
    static let semitransparentAlphaValue: CGFloat = 0.5
    static let unlockAttemptsCountUntilBlock: Int = 8
    static let blockTimerSecondsValue: TimeInterval = 5 * 60 // 5 minutes
    static let wrongAttemptsNumberSequenceLength = 64
    static let autoLockTimeoutSequence: [Int] = [
        0,     // autoLock disabled
        15,    // 15 sec
        30,    // 30 sec
        60,    // 1 min
        120,   // 2 min
        180,   // 3 min
        240,   // 4 min
        300,   // 5 min
        360,   // 6 min
        420,   // 7 min
        480,   // 8 min
        540,   // 9 min
        600,   // 10 min
        660,   // 11 min
        720,   // 12 min
        780,   // 13 min
        840,   // 14 min
        900,   // 15 min
        960,   // 16 min
        1020,   // 13 min
        1080,   // 12 min
        1140,   // 2 min
        1200,   // 3 min
        1260,   // 4 min
        1320,   // 5 min
        1380,   // 6 min
        1440,   // 7 min
        1500,   // 25 min
        1560,   // 26 min
        1620,   // 27 min
        1680,   // 28 min
        1740,   // 29 min
        1800   // 30 min
    ]
    static let appearAnimationDuration: TimeInterval = 0.25
    static let ellipsizeMemoTitleLongerThan: Int = 32
}
