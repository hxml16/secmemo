//
//  FileStorageMock.swift
//  secmemoTests
//
//  Created by heximal on 06.03.2022.
//

import Foundation
@testable import secmemo

class FileStorageMock: DataStorage {
    private var files: [String: Data?] = [:]
    let rootDirPath: String = "/"
    
    private var mockData: Data {
        return Data()
    }
    
    private func data(from string: String) -> Data {
        return string.data(using: .utf8)!
    }
    
    private func string(from data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }

    func readTextItem(at path: String) -> String? {
        if let fileData = readItem(at: path) {
            return string(from: fileData)
        }
        return nil
    }
    
    func saveTextItem(at path: String, text: String) -> Bool {
        files[path] = data(from: text)
        return true
    }
    
    func readItem(at path: String) -> Data? {
        return files[path] as? Data
    }
    
    func saveItem(at path: String, data: Data) -> Bool {
        files[path] = data
        return true
    }
    
    func itemExists(at path: String) -> Bool {
        return files[path] != nil
    }
    
    func createDir(at path: String) -> Bool {
        files[path] = mockData
        return true
    }
    
    func removeItem(path: String) {
        files[path] = nil
    }
}
