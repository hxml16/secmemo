//
//  String+Localizable.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation

//MARK: Localization routines
public extension String {
    func localized(values: [String: String]?) -> String {
        var res = self.localized
        guard let values = values else {
            return res
        }
        for (k, v) in values {
            res = res.replacingOccurrences(of: "{\(k)}", with: v)
        }
        return res
    }
    
    var localized: String {
        let bundle = Bundle.main
        
        let result = bundle.localizedString(forKey: self, value: nil, table: "Target")
        if result == self {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return result
    }
    
        
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var floatValue: Float? {
        return Float(self)
    }
}
