//
//  TimeInterval+String.swift
//  secmemo
//
//  Created by heximal on 02.05.2022.
//

import Foundation
import RxSwift

extension TimeInterval {
    var hhmmssValue: String {
        let h = Int(self / 3600)
        let m = Int((self - TimeInterval(h) * 3600) / 60)
        let s = Int(self - TimeInterval(h * 3600) - TimeInterval(m * 60))
        var parts = [String]()
        if h > 0 {
            parts.append(String(h))
        }
        parts.append(m > 9 ? String(m) : "0\(m)")
        parts.append(s > 9 ? String(s) : "0\(s)")
        return parts.joined(separator: ":")
    }
}
