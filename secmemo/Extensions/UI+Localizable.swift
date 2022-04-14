//
//  UI+Localizable.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import UIKit

extension UILabel {
    @IBInspectable public var lzText : String? {
        set {
            if newValue != nil {
                self.text = newValue!.localized
            }
            else {
                self.text = nil
            }
        }
        
        get {
            return self.text
        }
    }
    
    func toUpper() {
        self.text = self.text?.uppercased()
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UIButton {
    @IBInspectable public var lzButtonTitle : String? {
        set {
            if newValue != nil {
                self.setTitle(newValue?.localized, for: .normal)
            }
            else {
                self.setTitle(nil, for: .normal)
            }
        }
        
        get {
            return self.title(for: .normal)
        }
    }
    
    func toUpper() {
        self.setTitle(self.title(for: .normal)?.uppercased(), for: .normal)
    }
    
    func toLower() {
        self.setTitle(self.title(for: .normal)?.lowercased(), for: .normal)
    }
}

extension UITextField {
    
    @IBInspectable public var lzPlaceholder : String? {
        set {
            self.placeholder = newValue!.localized
        }
        
        get {
            return self.placeholder
        }
    }
}

extension TextField {
    private func setPlaceholderTextColorToOwner(color: UIColor?) {
        if let color = color {
            attributedPlaceholder = NSAttributedString(
                string: self.placeholder!,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        }
    }
    
    @IBInspectable public var placeholderTextColor : UIColor? {
        set {
            _placeholderTextColor = newValue
            setPlaceholderTextColorToOwner(color: newValue)
        }
        
        get {
            return _placeholderTextColor
        }
    }

    @IBInspectable public override var lzPlaceholder : String? {
        set {
            self.placeholder = newValue!.localized
            setPlaceholderTextColorToOwner(color: _placeholderTextColor)
        }
        
        get {
            return self.placeholder
        }
    }
}

extension UIViewController {
    @IBInspectable public var lzTitle : String? {
        set {
            self.title = newValue!.localized
        }
        
        get {
            return self.title
        }
    }
}
