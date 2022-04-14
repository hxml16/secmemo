//
//  EditMemoViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxPermission
import Permission
import RxCocoa

class EditMemoViewModel {
    var onImageViewerRequested = PublishSubject<MemoImageEntryDataSource>()
    let dataSource = BehaviorRelay<[MemoEntry]>(value: [])
    var focusOnEntry: MemoEntry?
    var currentResopnder: UIResponder?
    let entriesCount = BehaviorSubject<Int>(value: 0)
    let memoTitle = BehaviorSubject<String>(value: "")
    let memoTitlePlaceholder = BehaviorSubject<String>(value: "")
    let didRequestPhotoLibrary = PublishSubject<Void>()
    let didRequestCamera = PublishSubject<Void>()
    let didRequestDismission = PublishSubject<Void>()
    var memoChanged = false

    var entries: [MemoEntry] {
        set {
            memo.entries = newValue
        }
        
        get {
            return memo.entries
        }
    }
    private let disposeBag = DisposeBag()

    let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
    let memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
        acceptDataSource(memo.entries)
        memoTitle.onNext(memo.title)
        let defaultTitle = String(format: "memoEdit.newMemoTitle".localized, String(memo.id))
        memoTitlePlaceholder.onNext(defaultTitle)
    }
    
    func makeCurrentResponderFirst() {
        if let responder = currentResopnder {
            responder.paste(UIPasteboard.general.string)
        }
    }
    
    func addTextEntry() {
        addMemoEntry(entry: memo.generateNewMemoEntry(with: .text))
    }

    func addLocationEntry() {
        addMemoEntry(entry: memo.generateNewMemoEntry(with: .location))
    }

    func addPhotoEntry(image: UIImage) {
        let imageEntry = MemoImageEntry.imageEntry(with: image, memo: memo)
        if entries.count > 0, let imageCollection = entries.last as? MemoImageCollectionEntry {
            imageCollection.addEntry(imageEntry: imageEntry)
        } else {
            let imageCollection = memo.generateNewMemoEntry(with: .imageCollection) as! MemoImageCollectionEntry
            imageCollection.addEntry(imageEntry: imageEntry)
            entries.append(imageCollection)
        }
        imageEntry.save()
        var newEntries = [MemoEntry]()
        newEntries.append(contentsOf: entries)
        applyNewEntries(newEntries: newEntries)
        memoChanged = true
    }
    
    func removeMemo() {
        let message = String(format: "memos.deleteItemConfirmText".localized, String(format: "memoEdit.newMemoTitle".localized, String(memo.id)))
        showOkCancelAlert(message: message, okTitle: "common.ok".localized, inController: nil) {
            self.memo.remove()
            self.didRequestDismission.onNext(Void())
        } cancelComplete: {
        }
    }
    
    func requestPhotoEntry() {
        Permission
            .photos
            .rx.permission
            .subscribe(onNext: { [weak self] status in
                if status == .authorized {
                    self?.didRequestPhotoLibrary.onNext(Void())
                }
            })
            .disposed(by: disposeBag)
    }
    
    func requestCameraEntry() {
        Permission
            .camera
            .rx.permission
            .subscribe(onNext: { [weak self] status in
                if status == .authorized {
                    self?.didRequestCamera.onNext(Void())
                }
            })
            .disposed(by: disposeBag)
    }
    
    func requestImageViewer(selectedImageEntry: MemoImageEntry) {
        let memoImageEntryDataSource = MemoImageEntryDataSource(memoEntries: memo.entries, selectedMemoImageEntry: selectedImageEntry)
        onImageViewerRequested.onNext(memoImageEntryDataSource)
    }

    func addMemoEntry(entry: MemoEntry) {
        var newEntries = [MemoEntry]()
        newEntries.append(contentsOf: entries)
        focusOnEntry = entry
        newEntries.append(focusOnEntry!)
        applyNewEntries(newEntries: newEntries)
        memoChanged = true
    }
    
    func removeImageEntry(imageEntry: MemoImageEntry) {
        showOkCancelAlert(message: "memoEdit.confirmImageDeletion".localized, okTitle: "common.delete".localized, inController: nil) {
            self.removeEntry(entry: imageEntry)
        } cancelComplete: {
        }
    }

    func removeEntry(at index: Int) {
        if index < entries.count {
            let entry = entries[index]
            showOkCancelAlert(message: "memoEdit.confirmEntryDeletion".localized, okTitle: "common.delete".localized, inController: nil) {
                self.removeEntry(entry: entry)
            } cancelComplete: {
            }
        }
    }

    func removeEntry(entry: MemoEntry) {
        var newEntries = [MemoEntry]()
        memo.removeEntry(entry: entry)
        entries = memo.entries
        newEntries.append(contentsOf: entries)
        applyNewEntries(newEntries: newEntries)
        memoChanged = true
    }

    private func applyNewEntries(newEntries: [MemoEntry]) {
        entries = newEntries
        acceptDataSource(newEntries)
        entriesCount.onNext(newEntries.count)
    }
    
    private func acceptDataSource(_ entries: [MemoEntry]) {
        dataSource.accept(entries)
    }
    
    func applyMemoTitle(title: String?) {
        if let title = title {
            memo.header?.title = title
        } else {
            memo.header?.title = ""
        }
        memoChanged = true
    }
    
    func preloadEntryData(entry: MemoEntry) {
        dataProvider.preloadMemoEntry(entry: entry)
    }

    func save() {
        if memoChanged {
            memo.save()
        }
    }
}
