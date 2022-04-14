//
//  MemoHeader.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation

class MemoHeader: DataEntity {
    var id: Int
    var title: String
    var createdAt: Int = 0
    var updatedAt: Int = 0

    override var dict: [String: Any] {
        var temp = super.dict
        temp["id"] = id
        temp["title"] = title
        temp["createdAt"] = createdAt
        temp["updatedAt"] = updatedAt
        return temp
    }
    
    static func memoHeader(from dict: [String: Any]) -> MemoHeader? {
        if let id = dict["id"] as? Int, let title = dict["title"] as? String {
            let memoHeader = MemoHeader(id: id, title: title)
            if let createdAt = dict["createdAt"] as? Int {
                memoHeader.createdAt = createdAt
            }
            if let updatedAt = dict["updatedAt"] as? Int {
                memoHeader.updatedAt = updatedAt
            }
            return memoHeader
        }
        return nil
    }
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    func initTimeStamps() {
        updateCreated()
        updateUpdated()
    }
    
    func updateCreated() {
        createdAt = Int(Date().timeIntervalSince1970)
    }

    func updateUpdated() {
        updatedAt = Int(Date().timeIntervalSince1970)
    }
    
    override func remove() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        dataProvider.remove(memo: self)
    }
}
