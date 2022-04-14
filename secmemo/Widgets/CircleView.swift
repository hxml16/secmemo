//
//  CircleView.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import UIKit

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
    }
}
