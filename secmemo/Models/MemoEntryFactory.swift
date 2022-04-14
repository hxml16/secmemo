//
//  MemoEntryFactory.swift
//  secmemo
//
//  Created by heximal on 09.03.2022.
//

import Foundation

class MemoEntryFactory {
    // Method for creating empty memo enrty instance
    // with specified entry type (text, location, photo)
    static func memoEntry(with entryType: MemoEntryType) -> MemoEntry {
        return memoEntry(with: entryType, dict: nil)
    }
    
    // Method for creating memo entry instance from deserialized
    // JSON dictionary (previously saved entry)
    static func memoEntry(with dict: [String: Any]?) -> MemoEntry {
        if let entryTypeInt = dict?["type"] as? Int, let entryType = MemoEntryType(rawValue: entryTypeInt) {
            let memoEntry = memoEntry(with: entryType, dict: dict)
            if let hash = dict?["hash"] as? String {
                memoEntry.hash = hash
                return memoEntry
            }
        }
        return MemoEntry()
    }
    
    // Method for creating memo entry instance with specified entry type
    // (text, location, photo) and filled with deserialized data dictionary
    static func memoEntry(with entryType: MemoEntryType, dict: [String: Any]?) -> MemoEntry {
        var memoEntry: MemoEntry
        switch entryType {
            case .text:
                memoEntry = MemoTextEntry()
            case .location:
                memoEntry = MemoLocationEntry()
            case .image:
                memoEntry = MemoImageEntry()
            case .imageCollection:
                memoEntry = MemoImageCollectionEntry()
                if let dict = dict, let memoEntry = memoEntry as? MemoImageCollectionEntry {
                    memoEntry.unpackEntries(from: dict)
                }
            default:
                memoEntry = MemoEntry()
        }
        return memoEntry
    }
}
