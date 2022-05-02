//
//  UIColor+Extension.swift
//  secmemo
//
//  Created by heximal on 28.02.2022.
//

import Foundation
import UIKit

//MARK: Color routines
extension UIColor {
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func rgbFloat() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        if let rgb = rgb() {
            return (red: CGFloat(rgb.red) / 255.0, green: CGFloat(rgb.green) / 255.0, blue: CGFloat(rgb.blue) / 255.0, alpha: CGFloat(rgb.alpha) / 255.0)
        }
        return nil
    }
}
