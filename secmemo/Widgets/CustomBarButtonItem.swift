//
//  CustomBarButtonItem.swift
//  secmemo
//
//  Created by heximal on 12.02.2022.
//

import UIKit

@IBDesignable
class CustomBarButtonItem: UIBarButtonItem {
    @IBInspectable
    var scaledHeight: CGFloat = 0 {
        didSet {
            self.image = self.image?.scale(to: CGSize(width: self.scaledHeight, height: self.scaledWidth))
        }
    }

    @IBInspectable
    var scaledWidth: CGFloat = 0 {
        didSet {
            self.image = self.image?.scale(to: CGSize(width: self.scaledHeight, height: self.scaledWidth))
        }
    }
}
