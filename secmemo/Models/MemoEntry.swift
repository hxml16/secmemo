//
//  MemoEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation

typealias EntryDataDictionary = [String: Any]

class MemoEntry: DataEntity {
    var memoId: Int = -1
    var dataLoaded: Bool {
        false
    }
    
    var type: MemoEntryType  {
        return MemoEntryType.base
    }
    
    var data: Data {
        get {
            return Data()
        }
        
        set {
            
        }
    }
    
    func entryDataDictionary(data: Data) -> EntryDataDictionary {
        return [hash: data]
    }
    
    var hash = UUID().uuidString
    
    override var dict: [String: Any] {
        var temp = super.dict
        temp["type"] = type.rawValue
        temp["hash"] = hash
        return temp
    }
    
    override func save() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        let _ = dataProvider.save(entry: self)
    }
    
    override func remove() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        dataProvider.remove(entry: self)
    }
}
