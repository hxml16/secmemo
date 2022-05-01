//
//  MemoLinkEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation

class MemoLinkEntry: MemoTextEntry {
    override var type: MemoEntryType  {
        return MemoEntryType.link
    }    
}
