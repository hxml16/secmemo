//
//  FileStorageImpl.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation

class FileStorageImpl: DataStorage {
    let fileManager = FileManager.default
    
    var rootDirPath: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
        return documentsDirectory.path
    }
    
    func readTextItem(at path: String) -> String? {
        do {
            let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return data
        } catch {
            print("Error: Unable to read file at \(path): \(error)")
        }
        return nil
    }

    func saveTextItem(at path: String, text: String) -> Bool {
        if let data =  text.data(using: .utf8) {
            return saveItem(at: path, data: data)
        }
        return false
    }

    func readItem(at path: String) -> Data? {
        guard let pathUrl = URL(string: path.filePrefixed) else {
            print("Error: Unable to produce URL object from string \(path)")
            return nil
        }
        do {
            let data = try Data(contentsOf: pathUrl)
            return data
        } catch {
            print("Error: Unable to read file at \(path): \(error)")
        }
        return nil
    }


    func saveItem(at path: String, data: Data) -> Bool {
        guard let pathUrl = URL(string: path.filePrefixed) else {
            print("Error: Unable to produce URL object from string \(path)")
            return false
        }
        
        do {
            try data.write(to: pathUrl)
            return true
        } catch {
            print("Error: Unable to write file at \(path): \(error)")
        }
        return false
    }

    func itemExists(at path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    func createDir(at path: String) -> Bool {
        guard let pathUrl = URL(string: path.filePrefixed) else {
            return false
        }
        do {
            try fileManager.createDirectory(at: pathUrl, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("Error: Unable to create directory: \(error)")
        }
        return false
    }
    
    func removeItem(path: String) {
        guard let pathUrl = URL(string: path.filePrefixed) else {
            return
        }
        do {
            if itemExists(at: path) {
                try fileManager.removeItem(at: pathUrl)
            } else {
                print("File does not exist")
            }
        } catch {
            print("An error took place: \(error)")
        }
    }
}
