//
//  UIImage+Helper.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

extension UIImage {
    class func image(with color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func scale(to newSize: CGSize) -> UIImage {
        let koef = newSize.height / self.size.height
        let sizeScaled = CGSize(width: self.size.width * koef, height: self.size.height * koef)
        UIGraphicsBeginImageContextWithOptions(sizeScaled, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: sizeScaled.width, height: sizeScaled.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
