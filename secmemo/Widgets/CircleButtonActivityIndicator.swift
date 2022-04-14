//
//  CircleButtonActivityIndicator.swift
//  secmemo
//
//  Created by heximal on 01.03.2022.
//

import Foundation
import UIKit

class CircleButtonActivityIndicator: GCActivityIndicator {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        hidesWhenStopped = true
        let baseColor = Colors.primaryText.color
        if let baseColorRgb = baseColor.rgbFloat() {
            let lineWidth: CGFloat = 0.04
            var rings: [ActivityRing] = [
                ActivityRing(color: baseColor.cgColor, start: CGFloat(0.0), end: CGFloat(0.6), clockwise: true, lineWidth: lineWidth, overlaps: true)
            ]
            var a: CGFloat = 1.0
            let gradientSteps: Int = 8
            let totalLineLength: CGFloat = 0.2
            let stepLineLength: CGFloat = totalLineLength / CGFloat(gradientSteps)
            let alphaStep: CGFloat = 1.0 / CGFloat(gradientSteps)
            var currentStart: CGFloat = 0.59
            for _ in 0 ... gradientSteps - 1 {
                a -= alphaStep
                let color = UIColor(red: baseColorRgb.red, green: baseColorRgb.green, blue: baseColorRgb.blue, alpha: a)
                rings.append(
                    ActivityRing(color: color.cgColor, start: currentStart, end: currentStart + stepLineLength, clockwise: true, lineWidth: lineWidth, overlaps: true)
                )
                currentStart += stepLineLength
            }
            self.rings = rings
            stopAnimating()
        }
    }

}
