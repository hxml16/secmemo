//
//  UIDevice+Extension.swift
//  secmemo
//
//  Created by heximal on 20.04.2022.
//

import UIKit

extension UIDevice {
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
