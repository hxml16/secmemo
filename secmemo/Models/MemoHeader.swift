//
//  MemoHeader.swift
//  secmemo
//
//  Created by heximal on 06.03.2022.
//

import Foundation
import RxSwift

class MemoHeader: DataEntity {
    var id: Int
    var title: String {
        didSet {
            let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
            dataProvider.onMemoHeaderChanged.onNext(self)
        }
    }
    var createdAt: Int = 0
    var updatedAt: Int = 0

    let titleSubject = BehaviorSubject<String>(value: "")
    var titleOnInit: String?
    var isChanged: Bool {
        return title != titleOnInit
    }

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
        self.titleOnInit = title
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
        id = -1
    }
}

//MARK: Helper methods
extension MemoHeader {
    static func templateMemoTitle(memoId: Int) -> String {
        return String(format: "memoEdit.newMemoTitle".localized, String(memoId))
    }
    
    var shortifiedTitle: String {
        var message = MemoHeader.templateMemoTitle(memoId: id)
        if title.trimmed != "" {
            message = title.trimmed
            if message.count > GlobalConstants.ellipsizeMemoTitleLongerThan {
                message = message.prefix(GlobalConstants.ellipsizeMemoTitleLongerThan) + "..."
            }
        }
        return message
    }
}
