//
//  String+Json.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation

extension String {
    var dictionary: [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
    
    func appendingPathComponent(_ pathComponent: String) -> String {
        var res = self
        if res.last != "/" {
            res += "/"
        }
        return "\(res)\(pathComponent)"
    }
    
    var filePrefixed: String {
        var res = self
        let filePrefix = "file://"
        if !res.starts(with: filePrefix) {
            res = filePrefix + res
        }
        return res
    }
}
