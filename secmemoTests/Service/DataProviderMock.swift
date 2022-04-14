//
//  DataProviderMock.swift
//  secmemoTests
//
//  Created by heximal on 10.02.2022.
//

import Foundation
import RxSwift
@testable import secmemo

class DataProviderMock: DataProvider {
    private let testMemoId = 16
    private let testMemoTitle = "Test title"
    private let testMemoTimestamp = 1646595309
    private var savedData: [String: Data] = [:]

    var isAvailable = true
    var onError = PublishSubject<Error>()
    var onDataChanged = PublishSubject<Void>()
    
    var memoCount: Int {
        return 0
    }
    
    func preloadMemoEntry(entry: MemoEntry?) {
        if let entry = entry, let data = savedData[entry.hash] {
            entry.data = data
        }
    }
    
    func generateNewMemo() -> Memo? {
        return Memo.memo(id: testMemoId, title: testMemoTitle)
    }
    
    func fetchAllMemoHeaders() -> [MemoHeader] {
        return []
    }
    
    func fetchMemo(with id: Int) -> Memo? {
        Memo.memo(id: id, title: testMemoTitle)
    }
    
    func save(memo: Memo) {
    }
    
    func save(entry: MemoEntry) -> Bool {
        savedData[entry.hash] = entry.data
        return true
    }
    
    func remove(entry: MemoEntry) {
        savedData[entry.hash] = nil
    }

    func remove(memo: MemoHeader) {
    }
    
    func cleanupAllData() {
    }
}
