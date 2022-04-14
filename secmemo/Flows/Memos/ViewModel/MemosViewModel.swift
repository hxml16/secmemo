//
//  MemosViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

class MemosViewModel {
    let onError = PublishSubject<Error>()
    let status = BehaviorSubject<String>(value: "")
    let didRequestEditDocument = PublishSubject<Memo>()
    let didRequestNewDocument = PublishSubject<Void>()
    let didRequestSettings = PublishSubject<Void>()
    private var allMemoHeaders = [MemoHeader]()
    let items = BehaviorRelay<[MemoHeader]>(value: [])
    private let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
    private let disposeBag = DisposeBag()

    init() {
        rebuildDataSource()
        setupBindings()
    }
    
    func rebuildDataSource() {
        fetchMemoHeaders()
        updateStatus()
    }
    
    private func setupBindings() {
        dataProvider.onDataChanged
            .subscribe ( onNext: { [weak self] in
                self?.fetchMemoHeaders()
                self?.updateStatus()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateStatus() {
        if !dataProvider.isAvailable {
            status.onNext(Errors.initStorageFailed.error.localizedDescription)
        }
        if allMemoHeaders.count == 0 {
            status.onNext("memos.noMemosYet".localized)
        } else {
            status.onNext("")
        }
    }
    
    func removeMemo(at index: Int) {
        if index >= allMemoHeaders.count {
            return
        }
        let memo = allMemoHeaders[index]
        let message = String(format: "memos.deleteItemConfirmText".localized, String(format: "memoEdit.newMemoTitle".localized, String(memo.id)))
        showOkCancelAlert(message: message, okTitle: "common.delete".localized, inController: nil) {
            self.allMemoHeaders.remove(at: index)
            memo.remove()
            self.rebuildDataSource()
        } cancelComplete: {
        }
    }
    
    func fetchMemoHeaders() {
        if !dataProvider.isAvailable {
            return
        }
        allMemoHeaders = dataProvider.fetchAllMemoHeaders()
        let itemsSorted = allMemoHeaders.sorted { item1, item2 in
            return item1.updatedAt > item2.updatedAt
        }
        allMemoHeaders = itemsSorted
        items.accept(itemsSorted)
    }
    
    func requestEditDocument(memoHeader: MemoHeader) {
        if !dataProvider.isAvailable {
            return
        }
        if let memo = dataProvider.fetchMemo(with: memoHeader.id) {
            didRequestEditDocument.onNext(memo)
        }
    }
    
    func requestNewDocument() {
        if !dataProvider.isAvailable {
            onError.onNext(Errors.initStorageFailed.error)
            return
        }
        didRequestNewDocument.onNext(Void())
    }

    func requestSettigns() {
        didRequestSettings.onNext(Void())
    }
}
