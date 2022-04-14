//
//  DataProvider.swift
//  secmemo
//
//  Created by heximal on 10.02.2022.
//

import Foundation
import RxSwift

protocol DataProvider {
    var isAvailable: Bool { get }
    var onError: PublishSubject<Error> { get }
    var onDataChanged: PublishSubject<Void> { get }
    var memoCount: Int { get }

    func preloadMemoEntry(entry: MemoEntry?)
    func generateNewMemo() -> Memo?
    func fetchAllMemoHeaders() -> [MemoHeader]
    func fetchMemo(with id: Int) -> Memo?
    func save(memo: Memo)
    func save(entry: MemoEntry) -> Bool
    func remove(memo: MemoHeader)
    func remove(entry: MemoEntry)
    func cleanupAllData()
}
