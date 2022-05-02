//
//  UIView+Inspectable.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

import UIKit

//MARK: Inspectable vars
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
