//
//  GradientView.swift
//  secmemo
//
//  Created by heximal on 28.03.2022.
//

import Foundation
import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var startColor: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endColor: UIColor = .green {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradientLayer()
    }

    func configureGradientLayer(){
        backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
