//
//  Memo.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation

class Memo: DataEntity {
    var header: MemoHeader?
    var entries = [MemoEntry]()
    var entriesCollectionChanged = false
    var isChanged: Bool {
        get {
            return
                entries.filter { entry in return entry.isChanged }.count > 0 ||
                entriesCollectionChanged ||
                header?.isChanged == true
        }
        
        set {
            for entry in entries {
                entry.isChanged = newValue
            }
            entriesCollectionChanged = newValue
        }
    }

    var title: String {
        get {
            if let header = header {
                return header.title
            }
            return ""
        }
        
        set {
            header?.title = newValue
        }
    }
    
    var id: Int {
        if let header = header {
            return header.id
        }
        return -1
    }

    var createdAt: Int {
        get {
            if let header = header {
                return header.createdAt
            }
            return 0
        }
        set {
            header?.createdAt = newValue
        }
    }

    var updatedAt: Int {
        get {
            if let header = header {
                return header.updatedAt
            }
            return 0
        }
        set {
            header?.updatedAt = newValue
        }
    }
    
    var entriesCount: Int {
        return entries.count
    }
    
    var lastEntry: MemoEntry? {
        return entries.last
    }
    
    func reinitTimestamps() {
        header?.initTimeStamps()
    }

    override var dict: [String: Any] {
        var temp = super.dict
        var entryDicts: [[String: Any]] = []
        for entry in entries {
            entryDicts.append(entry.dict)
        }
        if let header = header {
            temp["header"] = header.dict
        }
        temp["entries"] = entryDicts
        return temp
    }

    static var empty: Memo {
        return memo(id: -1, title: "")
    }

    static func memo(id: Int, title: String) -> Memo {
        let memo = Memo()
        memo.header = MemoHeader(id: id, title: title)
        memo.header?.initTimeStamps()
        return memo
    }

    static func memo(from dict: [String: Any]) -> Memo? {
        if let headerDict = dict["header"] as? [String: Any], let memoHeader = MemoHeader.memoHeader(from: headerDict), let memo = memo(from: dict, with: memoHeader) {
            return memo
        }
        return nil
    }
    
    static func memo(from dict: [String: Any], with memoHeader: MemoHeader) -> Memo? {
        let memo = memo(with: memoHeader)
        memo?.entries = []
        if let memo = memo, let entries = dict["entries"] as? [[String: Any]] {
            for entryDict in entries {
                let memoEntry = MemoEntryFactory.memoEntry(with: entryDict)
                memoEntry.memoId = memo.id
                memo.entries.append(memoEntry)
            }
        }
        return memo
    }

    static func memo(with memoHeader: MemoHeader) -> Memo? {
        let memo = Memo()
        memo.header = memoHeader
        return memo
    }

    override func save() {
        guard let header = self.header, header.id >= 0 else {
            return
        }
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        header.updateUpdated()
        dataProvider.save(memo: self)
    }
    
    override func remove() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        header?.updateUpdated()
        if let header = self.header {
            dataProvider.remove(memo: header)
            self.header?.id = -1
        }
    }
    
    func generateNewMemoEntry(with entryType: MemoEntryType) -> MemoEntry {
        let memoEntry = MemoEntryFactory.memoEntry(with: entryType)
        memoEntry.memoId = self.id
        return memoEntry
    }
    
    func addEntry(entry: MemoEntry) {
        entriesCollectionChanged = true
        entries.append(entry)
    }
    
    func removeEntry(entry: MemoEntry) {
        if let entryIndex = entries.firstIndex(where: { existingEntry in
            existingEntry.hash == entry.hash
        }) {
            entries.remove(at: entryIndex)
        } else {
            if let imageCollectionEntries = entries.filter({ existingEntry in
                existingEntry.type == .imageCollection
            }) as? [MemoImageCollectionEntry] {
                for imageCollectionEntry in imageCollectionEntries {
                    if let entryIndex = imageCollectionEntry.entries.firstIndex(where: { existingEntry in
                        existingEntry.hash == entry.hash
                    }) {
                        imageCollectionEntry.entries.remove(at: entryIndex)
                        if imageCollectionEntry.entries.count == 0 {
                            removeEntry(entry: imageCollectionEntry)
                        }
                        break
                    }
                }
            }
        }
        entry.remove()
        entriesCollectionChanged = true
    }
}
