//
//  MemoTextEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation

class MemoTextEntry: MemoEntry {
    override var dataLoaded: Bool {
        return _text != nil
    }

    override var type: MemoEntryType  {
        return MemoEntryType.text
    }
    
    override var data: Data {
        get {
            if let text = _text, let textData = text.data(using: .utf8) {
                return textData
            }
            return super.data
        }
        
        set {
            if let newText = String(data: newValue, encoding: .utf8) {
                _text = newText
            }
        }
    }

    private var _text: String?
    var text: String? {
        set {
            isChanged = _text != newValue
            _text = newValue
        }
        
        get {
            return _text
        }
    }
}
