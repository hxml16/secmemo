//
//  String+Parse.swift
//  secmemo
//
//  Created by heximal on 29.04.2022.
//

import Foundation
import UIKit

//MARK: Parse routines
extension String {
    var parsedHyperlinks: [String] {
        let types = NSTextCheckingResult.CheckingType.link

        let detector = try? NSDataDetector(types: types.rawValue)

        guard let detect = detector else {
           return []
        }

        let matches = detect.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))

                                     
        return matches.compactMap({$0.url?.absoluteString})
    }
    
    var isHyperlink: Bool {
        if let url = self.url {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    var url: URL? {
        return URL(string: self)
    }
}
