//
//  TextField.swift
//  secmemo
//
//  Created by heximal on 27.02.2022.
//

import Foundation
import UIKit

class TextField: UITextField {
    private var _placeholderTextColorInt: UIColor?
    
    var _placeholderTextColor: UIColor? {
        set {
            _placeholderTextColorInt = newValue
        }
        get {
            return _placeholderTextColorInt
        }
    }
}
