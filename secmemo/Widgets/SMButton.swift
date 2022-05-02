//
//  SMButton.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import UIKit

class SMButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? GlobalConstants.opaqueAlphaValue : GlobalConstants.semitransparentAlphaValue
        }
    }
}
