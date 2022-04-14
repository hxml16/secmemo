//
//  CircleButton.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import UIKit

class CircleButton: UIButton {
    private var _highlightedBackgroundColor = UIColor.clear
    
    @IBInspectable
    var highlightedBackgroundColor: UIColor? {
        set {
            if let newColor = newValue {
                _highlightedBackgroundColor = newColor
                setBackgroundImage(UIImage.image(with: newColor), for: .highlighted)
            }
        }
        
        get {
            return _highlightedBackgroundColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
    }
}
