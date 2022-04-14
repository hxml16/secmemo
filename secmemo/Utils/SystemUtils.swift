//
//  SystemUtils.swift
//  secmemo
//
//  Created by heximal on 02.03.2022.
//

import Foundation
import UIKit

class SystemUtils {
    static func openAppSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
