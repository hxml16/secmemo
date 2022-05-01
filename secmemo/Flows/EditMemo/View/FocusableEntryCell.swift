//
//  FocusableEntryCell.swift
//  secmemo
//
//  Created by heximal on 30.04.2022.
//

import UIKit

protocol FocusableEntryCell {
    var focusableView: UIView? { get }
    func focus()
}

extension FocusableEntryCell {
    func focus() {
        focusableView?.becomeFirstResponder()
    }
}
