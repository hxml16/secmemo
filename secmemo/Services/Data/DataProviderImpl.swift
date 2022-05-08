//
//  DataProviderImpl.swift
//  secmemo
//
//  Created by heximal on 03.03.2022.
//

import Foundation
import RxSwift

class DataProviderImpl: DataProvider {
    let errorSubject = PublishSubject<Error>()
    let dataChangedSubject = PublishSubject<Void>()
    var onMemoHeaderChanged = PublishSubject<MemoHeader>()
    private var allMemoHeaders = [MemoHeader]()
    private var dataStorage: DataStorage
    private var dataDir: String
    private var memosDataDir: String
    private var available = false
    private var lastId: Int = 0

    var memoCount: Int {
        return allMemoHeaders.count
    }
    
    var isAvailable: Bool {
        return available
    }

    var onError: PublishSubject<Error> {
        return errorSubject
    }

    var memosJsonPath: String {
        return dataDir.appendingPathComponent("memos.json")
    }
    
    var onDataChanged: PublishSubject<Void> {
        return dataChangedSubject
    }


    init(dataStorage: FileStorageImpl) {
        self.dataStorage = dataStorage
        dataDir = dataStorage.rootDirPath.appendingPathComponent("data")
        memosDataDir = dataDir.appendingPathComponent("memos")
        initDataProvider()
    }
    
    // Alternative constructor for Unit testing
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        dataDir = dataStorage.rootDirPath.appendingPathComponent("data")
        memosDataDir = dataDir.appendingPathComponent("memos")
        initDataProvider()
    }

    private func initDataProvider() {
        initDirectories()
        if available {
            readCatalog()
        }
    }
    
    func fetchAllMemoHeaders() -> [MemoHeader] {
        return allMemoHeaders
    }
    
    func generateNewMemo() -> Memo? {
        lastId += 1
        if !isMemoDirectoryAvailable(memoId: lastId) {
            reportError(error: .memoStorageFailed)
            return nil
        }
        let memo = Memo.memo(id: lastId, title: "")
        return memo
    }
    
    func nextMemoId() -> Int {
        return lastId + 1
    }
    
    func fetchMemo(with id: Int) -> Memo? {
        let memoJsonPath = memoJsonPath(memoId: id)
        if dataStorage.itemExists(at: memoJsonPath) {
            let memoJsonStr = dataStorage.readTextItem(at: memoJsonPath)
            if let json = memoJsonStr, let dict = json.dictionary {
                if let memo = Memo.memo(from: dict) {
                    return memo
                }
            }
        }

        return nil
    }
    
    func save(memo: Memo) {
        updateCatalogMemo(memo: memo)
        saveCatalog()
        if isMemoDirectoryAvailable(memoId: memo.id) {
            let memoDict = memo.dict
            
            let memoJsonPath = memoJsonPath(memoId: memo.id)
            let saved = dataStorage.saveTextItem(at: memoJsonPath, text: memoDict.json)
            if saved {
                for entry in memo.entries {
                    let _ = save(entry: entry)
                }
            }
        }
        dataChangedSubject.onNext(Void())
    }
    
    func save(entry: MemoEntry) -> Bool {
        let memoEntryPath = memoEntryDataPath(entry: entry)
        var saved = true
        if entry.data.count > 0 {
            saved = dataStorage.saveItem(at: memoEntryPath, data: entry.data)
        }
        return saved
    }
    
    func remove(entry: MemoEntry) {
        let memoEntryPath = memoEntryDataPath(entry: entry)
        dataStorage.removeItem(path: memoEntryPath)
    }

    func cleanupAllData() {
        dataStorage.removeItem(path: dataDir)
        initDirectories()
        allMemoHeaders.forEach({ $0.id = -1 })
        allMemoHeaders = []
        lastId = 0
    }

    func remove(memo: MemoHeader) {
        dataStorage.removeItem(path: memoDirPath(memoId: memo.id))
        if let index = allMemoHeaders.firstIndex(where: {$0.id == memo.id}) {
            allMemoHeaders.remove(at: index)
        }
        if allMemoHeaders.count <= 0 {
            lastId = 0
        }
        saveCatalog()
    }

    private func memoEntryDataPath(entry: MemoEntry) -> String {
        let path = memoDirPath(memoId: entry.memoId).appendingPathComponent(entry.hash)
        return path
    }

    private func memoEntryDataPath(memoId: String, hash: String) -> String {
        let path = memoDirPath(memoId: memoId).appendingPathComponent(hash)
        return path
    }

    private func memoEntryDataPaths(entry: MemoEntry) -> String {
        let path = memoDirPath(memoId: entry.memoId).appendingPathComponent(entry.hash)
        return path
    }
    
    private func memoJsonPath(memoId: Int) -> String {
        return memoDirPath(memoId: memoId).appendingPathComponent("memo.json")
    }
    
    private func memoDirPath(memoId: Int) -> String {
        return memoDirPath(memoId: String(memoId))
    }

    private func memoDirPath(memoId: String) -> String {
        return memosDataDir.appendingPathComponent(memoId)
    }

    private func updateCatalogMemo(memo: Memo) {
        let filteredMemos = allMemoHeaders.filter { $0.id == memo.id}
        if filteredMemos.count > 0 {
            filteredMemos[0].title = memo.title
            filteredMemos[0].createdAt = memo.createdAt
            filteredMemos[0].updatedAt = memo.updatedAt
        } else {
            if let header = memo.header {
                allMemoHeaders.append(header)
            }
        }
    }
    
    private func initDirectories() {
        available = true
        let dirsToCheck = [dataDir, memosDataDir]
        for dirPath in dirsToCheck {
            if !dataStorage.itemExists(at: dirPath) && !dataStorage.createDir(at: dirPath) {
                available = false
                reportError(error: .initStorageFailed)
                break
            }
        }
    }

    private func isMemoDirectoryAvailable(memoId: Int) -> Bool {
        let memoDataDirPath = memosDataDir.appendingPathComponent(String(memoId))
        return dataStorage.itemExists(at: memoDataDirPath) || dataStorage.createDir(at: memoDataDirPath)
    }

    private func readCatalog() {
        allMemoHeaders = []
        if dataStorage.itemExists(at: memosJsonPath) {
            let catalogJsonStr = dataStorage.readTextItem(at: memosJsonPath)
            if let json = catalogJsonStr, let dict = json.dictionary {
                if let lastId = dict["lastId"] as? Int {
                    self.lastId = lastId
                }
                if let memoHeaders = dict["memos"] as? [[String: Any]] {
                    for memoDict in memoHeaders {
                        if let memoHeader = MemoHeader.memoHeader(from: memoDict) {
                            allMemoHeaders.append(memoHeader)
                        }
                    }
                }
            }
        }
    }
    
    private func saveCatalog() {
        var memos: [[String: Any]] = []
        var maxId: Int = -1
        for memoHeader in allMemoHeaders {
            if memoHeader.id > maxId {
                maxId = memoHeader.id
            }
            memos.append(memoHeader.dict)
        }
        let catalog: [String: Any] = ["lastId": maxId, "memos": memos]
        let _ = dataStorage.saveTextItem(at: memosJsonPath, text: catalog.json)
    }
    
    func preloadMemoEntry(entry: MemoEntry?) {
        guard let entry = entry else {
            return
        }
        if !entry.dataLoaded {
            let memoEntryPath = memoEntryDataPath(entry: entry)
            if let data = dataStorage.readItem(at: memoEntryPath) {
                entry.data = data
            }
        }
    }
    
    private func reportError(error: Errors) {
        errorSubject.onNext(error.error)
    }
}
