//
//  MemoDataEntry.swift
//  secmemo
//
//  Created by heximal on 19.03.2022.
//

import Foundation

class MemoDataEntry: MemoEntry {
    private var _data: Data
    
    override var data: Data {
        get {
            return _data
        }
        
        set {
            _data = newValue
        }
    }
    
    init(data: Data, hash: String, memoId: Int) {
        self._data = data
        super.init()
        self.memoId = memoId
        self.hash = hash
    }
}
