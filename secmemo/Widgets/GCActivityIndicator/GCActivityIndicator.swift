//
//  GCActivityIndicator.swift
//  GCActivityIndicator
//
//  Created by Graham Chance on 7/29/18.
//  Copyright © 2018 Graham Chance. All rights reserved.
//

import Foundation
import UIKit

/// Models a view with some number of activity indicator rings.
public class GCActivityIndicator: UIView {
    
    static let rings = [
        [
            ActivityRing(color: UIColor(rgb: 0x0f3c6c).cgColor, start: 0, end: 0.6, clockwise: true, overlaps: true),
            ActivityRing(color: UIColor(rgb: 0xef4931).cgColor, start: 0.5, end: 1, clockwise: true, overlaps: true),
            ActivityRing(color: UIColor(rgb: 0x99bfbc).cgColor, start: 0.2, end: 0.6, clockwise: false, overlaps: true),
            ActivityRing(color: UIColor(rgb: 0xffd300).cgColor, start: 0.4, end: 0.8, clockwise: false, overlaps: true)
        ],
        
        [
            ActivityRing(color: UIColor(rgb: 0x0f3c6c).cgColor, start: 0, end: 0.6, clockwise: true, timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)),
            ActivityRing(color: UIColor(rgb: 0xef4931).cgColor, start: 0.5, end: 1, clockwise: true),
            ActivityRing(color: UIColor(rgb: 0x99bfbc).cgColor, start: 0.2, end: 0.6, clockwise: false),
            ActivityRing(color: UIColor(rgb: 0xffd300).cgColor, start: 0.4, end: 0.8, clockwise: false)
        ],
        
        [
            ActivityRing(color: UIColor.blue.cgColor, start: 0, end: 1, clockwise: true, lineWidth: 0.09),
            ActivityRing(color: UIColor.green.cgColor, start: 0.2, end: 0.8, clockwise: false, lineWidth: 0.1),
            ActivityRing(color: UIColor.green.cgColor, start: 0, end: 0.5, clockwise: true, lineWidth: 0.11, overlaps: true)
        ],
        
        [
            ActivityRing(color: UIColor(rgb: 0x0f3c6c).cgColor, start: 0, end: 0.5, clockwise: true, lineWidth: 0.13),
            ActivityRing(color: UIColor(rgb: 0xef4931).cgColor, start: 0.5, end: 1, clockwise: true, lineWidth: 0.13, overlaps: true)
        ],
        [
            ActivityRing(color: UIColor(rgb: 0x0f3c6c).cgColor, start: 0, end: 0.4, clockwise: true, lineWidth: 0.13),
            ActivityRing(color: UIColor(rgb: 0xef4931).cgColor, start: 0.6, end: 1, clockwise: true, lineWidth: 0.13, overlaps: true, timingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        ]
    ]

    /// Whether the view should hide when animation stops.
    public var hidesWhenStopped: Bool = true

    /// Whether the view is currently animating.
    public private(set) var isAnimating: Bool = false

    /// The ActivityRings belonging to the view.
    public var rings: [ActivityRing] = [] {
        didSet {
            configureRings()
        }
    }


    /// Required constructor
    ///
    /// - Parameter aDecoder: An unarchiver object.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }


    /// Construct with a frame
    ///
    /// - Parameter frame: Frame to assign to the view.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    /// Stops all animation of ActivityRings.
    public func stopAnimating() {
        isAnimating = false
        isHidden = hidesWhenStopped
        ringLayers.forEach {
            $0.currentAnimation = nil
        }
    }

    /// Starts animating all ActivityRings.
    public func startAnimating() {
        if isAnimating {
            return
        }
        isAnimating = true
        isHidden = false
        addAnimations()
    }

    private func configureView() {
        backgroundColor = UIColor.clear
        configureRings()
    }

    private var ringLayers: [ActivityRingLayer] {
        return (layer.sublayers ?? []).compactMap {
            return $0 as? ActivityRingLayer
        }
    }

    private func configureRings() {
        removeAllRings()
        addRingLayers()
    }

    private func addAnimations() {
        ringLayers.forEach {
            $0.startAnimating()
        }
    }

    private func removeAllRings() {
        ringLayers.forEach {
            $0.removeFromSuperlayer()
        }
    }

    private func addRingLayers() {
        let radii = calculateRadii()
        for i in 0..<rings.count {
            let ring = rings[i]
            let ringLayer = ActivityRingLayer(frame: bounds, ring: ring, radius: radii[i])
            layer.addSublayer(ringLayer)
        }
    }

    private func calculateRadii() -> [CGFloat] {
        var radii = [CGFloat]()
        let maxDiameter = min(bounds.width, bounds.height)
        let maxRadius = maxDiameter / 2
        for i in 0..<rings.count {
            let ring = rings[i]
            let radius: CGFloat
            if i == 0 {
                radius = maxRadius - ring.lineWidth * maxRadius
            } else if rings[i].overlaps {
                radius = radii[i-1] - (ring.lineWidth - rings[i-1].lineWidth) * maxRadius
            } else {
                radius = radii[i-1]
                    - (rings[i-1].lineWidth * maxDiameter) / 2
                    - (ring.lineWidth * maxDiameter) / 2
            }
            radii.append(radius)
        }
        return radii
    }

}


 extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
