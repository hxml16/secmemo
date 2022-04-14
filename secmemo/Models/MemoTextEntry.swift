//
//  MemoTextEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation

class MemoTextEntry: MemoEntry {
    override var dataLoaded: Bool {
        return text != nil
    }

    override var type: MemoEntryType  {
        return MemoEntryType.text
    }
    
    override var data: Data {
        get {
            if let text = text, let textData = text.data(using: .utf8) {
                return textData
            }
            return super.data
        }
        
        set {
            if let newText = String(data: newValue, encoding: .utf8) {
                self.text = newText
            }
        }
    }
    
    var text: String?
}
