//
//  MemosViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class MemosViewModel {
    let onError = PublishSubject<Error>()
    let status = BehaviorSubject<String>(value: "")
    let addMemoControlVisible = BehaviorSubject<Bool>(value: false)
    let didRequestEditDocument = PublishSubject<Memo>()
    let didRequestNewDocument = PublishSubject<Void>()
    let didRequestSettings = PublishSubject<Void>()
    private var allMemoHeaders = [MemoHeader]()
    let rowIndexSelected = BehaviorSubject<Int>(value: -1)
    let items = BehaviorRelay<[MemoHeader]>(value: [])
    private var restoreSelectedRowWithMemoId = -1
    private let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
    private let disposeBag = DisposeBag()
    private var lastSelectedMemoId: Int = -1

    init() {
        rebuildDataSource()
        setupBindings()
    }
    
    func rebuildDataSource() {
        fetchMemoHeaders()
        updateStatus()
        restorePreviouslySelectedItemIfRequired()
    }
    
    func resetRowSelectedIndex() {
        rowIndexSelected.onNext(-1)
    }
    
    private func restorePreviouslySelectedItemIfRequired() {
        selectMemo(with: restoreSelectedRowWithMemoId)
//        restoreSelectedRowWithMemoId = -1
    }
    
    private func selectMemo(with id: Int) {
        let memoRowIndex = rowIndex(with: id)
        selectMemo(at: memoRowIndex)
    }
    
    private func selectMemo(at row: Int) {
        if row >= 0 && row < allMemoHeaders.count {
            rowIndexSelected.onNext(row)
        }
    }
    
    private func rowIndex(with memoId: Int) -> Int {
        if allMemoHeaders.count <= 0 {
            return -1
        }
        for i in 0...allMemoHeaders.count - 1 {
            if allMemoHeaders[i].id == memoId {
                return i
            }
        }
        return -1
    }
    
    private func setupBindings() {
        dataProvider.onDataChanged
            .subscribe ( onNext: { [weak self] in
                self?.fetchMemoHeaders()
                self?.updateStatus()
                self?.restorePreviouslySelectedItemIfRequired()
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
        addMemoControlVisible.onNext(allMemoHeaders.count == 0)
    }
    
    func removeMemo(at index: Int) {
        if index >= allMemoHeaders.count {
            return
        }
        let memo = allMemoHeaders[index]
        let message = String(format: "memos.deleteItemConfirmText".localized, String(format: "memoEdit.newMemoTitle".localized, String(memo.id)))
        showOkCancelAlert(message: message, okTitle: "common.delete".localized, inController: nil) {
            self.allMemoHeaders.remove(at: index)
            if self.lastSelectedMemoId != memo.id {
                self.restoreSelectedRowWithMemoId = self.lastSelectedMemoId
            } else {
                self.restoreSelectedRowWithMemoId = -1
            }
            memo.remove()
            self.rebuildDataSource()
            if UIDevice.isPad && self.restoreSelectedRowWithMemoId < 0{
                self.requestEmptyDocument()
            }
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
        if UIDevice.isPad && allMemoHeaders.count == 0 {
            requestEmptyDocument()
        }
    }
    
    func requestEditDocument(memoHeader: MemoHeader) {
        if !dataProvider.isAvailable {
            return
        }
        if let memo = dataProvider.fetchMemo(with: memoHeader.id) {
            lastSelectedMemoId = memo.id
            restoreSelectedRowWithMemoId = memoHeader.id
            didRequestEditDocument.onNext(memo)
        }
    }
    
    // Just to show empty panel when no memo selected
    private func requestEmptyDocument() {
        didRequestEditDocument.onNext(Memo.empty)
    }
    
    func requestNewDocument() {
        lastSelectedMemoId = -1
        if !dataProvider.isAvailable {
            onError.onNext(Errors.initStorageFailed.error)
            return
        }
        restoreSelectedRowWithMemoId = -1
        if let newMemo = dataProvider.generateNewMemo() {
            newMemo.save()
            didRequestEditDocument.onNext(newMemo)
            newMemo.reinitTimestamps()
            selectMemo(with: newMemo.id)
        }
    }

    func requestSettigns() {
        didRequestSettings.onNext(Void())
    }
}
