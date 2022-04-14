//
//  DataStorage.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation

protocol DataStorage {
    var rootDirPath: String { get }
    func readTextItem(at path: String) -> String?
    func saveTextItem(at path: String, text: String) -> Bool
    func readItem(at path: String) -> Data?
    func saveItem(at path: String, data: Data) -> Bool
    func itemExists(at path: String) -> Bool
    func createDir(at path: String) -> Bool
    func removeItem(path: String)
}
