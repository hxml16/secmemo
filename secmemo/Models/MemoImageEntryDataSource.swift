//
//  MemoImageEntryDataSource.swift
//  secmemo
//
//  Created by heximal on 20.03.2022.
//

import Foundation

class MemoImageEntryDataSource: MemoImageCollectionEntry {
    var selectedEntryIndex: Int = 0
    
    init(memoEntries: [MemoEntry], selectedMemoImageEntry: MemoImageEntry) {
        super.init()
        if let firstMemoEntry = memoEntries.first {
            self.memoId = firstMemoEntry.memoId
        }
        let imageCollections = memoEntries.filter { memoEntry in
            memoEntry.type == .imageCollection
        }
        
        if let imageCollections = imageCollections as? [MemoImageCollectionEntry] {
            for imageCollection in imageCollections {
                entries.append(contentsOf: imageCollection.entries)
            }
            if let selectedEntryIndex = entries.firstIndex(where: { memoImageEntry in
                memoImageEntry.hash == selectedMemoImageEntry.hash
            }) {
                self.selectedEntryIndex = selectedEntryIndex
            }
        }
    }
}
