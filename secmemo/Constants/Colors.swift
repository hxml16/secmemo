//
//  Colors.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

enum Colors {
    case primaryText
    case memoTableSelectedBackgroundColor
    case memoEntrySplitterColor
    
    var color: UIColor {
        var colorName: String?
        switch self {
            case .primaryText:
                colorName = "CustomPrimaryTextColor"
            case .memoTableSelectedBackgroundColor:
                colorName = "CustomMemoTableSelectedBackgroundColor"
            case .memoEntrySplitterColor:
                colorName = "CustomMemoEntrySplitterColor"
        }
        if let cn = colorName, let color = UIColor(named: cn) {
            return color
        }
        return .clear
    }
}
