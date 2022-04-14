//
//  MemoImageCollectionEntry.swift
//  secmemo
//
//  Created by heximal on 13.03.2022.
//

import Foundation
import UIKit

class MemoImageCollectionEntry: MemoEntry {
    override var type: MemoEntryType {
        return .imageCollection
    }
    
    override var memoId: Int {
        didSet {
            for entry in entries {
                entry.memoId = self.memoId
            }
        }
    }
    
    var entries = [MemoImageEntry]()
    var count: Int {
        return entries.count
    }
    
    override var dict: [String: Any] {
        var _entries: [[String: Any]] = []
        var _dict = super.dict
        for entry in entries {
            _entries.append(entry.dict)
        }
        _dict["entries"] = _entries
        return _dict
    }
    
    func unpackEntries(from dict: [String: Any]) {
        entries = []
        if let _entries = dict["entries"] as? [[String: Any]] {
            for _entry in _entries {
                if let imageEntry = MemoImageEntry.imageEntry(with: _entry, memoId: memoId) {
                    entries.append(imageEntry)
                }
            }
        }
    }
    
    func addEntry(imageEntry: MemoImageEntry) {
        entries.append(imageEntry)
    }

    func removeEntry(imageEntry: MemoImageEntry) {
        if let entryIndex = entries.firstIndex(where: { memoImageEntry in
            memoImageEntry.hash == imageEntry.hash
        }) {
            entries.remove(at: entryIndex)
        }
    }
}
