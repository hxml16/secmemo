//
//  UIView+Inspectable.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

import UIKit

//MARK: Inspectable vars
extension UIView {
    @IBInspectable public var rotate : CGFloat {
        set {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi * newValue / 180)
        }
        
        get {
            return 0
        }
    }

    @IBInspectable public var layerCornerRadius : CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable public var layerBorderWidth : CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable public var layerBorderColor : UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
}

//MARK: Helpful methods
extension UIView {
    var visible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
    
    var globalPoint: CGPoint? {
          return self.superview?.convert(self.frame.origin, to: nil)
      }

      var globalFrame: CGRect? {
          return self.superview?.convert(self.frame, to: nil)
      }

    var globalBounds: CGRect? {
        return self.superview?.convert(self.bounds, to: nil)
    }
}
