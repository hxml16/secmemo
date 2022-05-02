//
//  Dictionary+Json.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation

//MARK: Json routines
extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }
}
