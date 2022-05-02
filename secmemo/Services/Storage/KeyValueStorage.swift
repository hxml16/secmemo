//
//  KeyValueStorage.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation

protocol KeyValueStorage {
    func remove(forKey: String)

    func value(forKey: String) -> AnyObject?
    func set(value: AnyObject?, forKey: String)
    
    func int(forKey: String) -> Int?
    func set(value: Int?, forKey: String)
    
    func float(forKey: String) -> Float?
    func set(value: Float?, forKey: String)
    
    func double(forKey: String) -> Double?
    func set(value: Double?, forKey: String)
    
    func string(forKey: String) -> String?
    func set(value: String?, forKey: String)
    
    func bool(forKey: String) -> Bool?
    func set(value: Bool?, forKey: String)
}
