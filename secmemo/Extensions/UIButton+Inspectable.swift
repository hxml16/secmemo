//
//  UIView+Inspectable.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

import UIKit

extension UIButton {
    @IBInspectable public var adjustsFontSizeToFitWidth : Bool {
        set {
            titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        get {
            titleLabel?.adjustsFontSizeToFitWidth == true
        }
    }
}
