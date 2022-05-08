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
import UIKit

class EditMemoViewModel {
    var onImageViewerRequested = PublishSubject<MemoImageEntryDataSource>()
    let dataSource = BehaviorRelay<[MemoEntry]>(value: [])
    var focusOnEntry: MemoEntry?
    var currentResponder: UIResponder?
    let entriesCount = BehaviorSubject<Int>(value: 0)
    let memoTitle = BehaviorSubject<String>(value: "")
    let bottomButtonsAvailable = BehaviorSubject<Bool>(value: UIDevice.isPhone)
    let memoTitlePlaceholder = BehaviorSubject<String>(value: "")
    let didRequestPhotoLibrary = PublishSubject<Void>()
    let didRequestCamera = PublishSubject<Void>()
    let didRequestDismission = PublishSubject<Void>()
    let memoApplied = BehaviorSubject<Bool>(value: false)

    private let disposeBag = DisposeBag()

    let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
    var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
        initMemoIfRequired()
        setupBindings()
    }
    
    private func setupBindings() {
        let sessionService = AppDelegate.container.resolve(SessionService.self)!
        sessionService.didSuspend
            .subscribe(onNext: { [weak self] in
                self?.save()
            })
            .disposed(by: disposeBag)
    }
    
    func applyNewMemo(memo: Memo) {
        if memo.isValid {
            save()
        }
        self.memo = memo
        initMemoIfRequired()
    }
    
    func emptyfyMemo() {
        self.memo = Memo.empty
    }
    
    private func initMemoIfRequired() {
        if memo.id < 0 {
            memoApplied.onNext(false)
            return
        }
        memo.isChanged = false
        // Show bottom controls only for iPhone devices
        memoApplied.onNext(true)
        acceptDataSource(memo.entries)
        memoTitle.onNext(memo.title)
        bottomButtonsAvailable.onNext(UIDevice.isPhone)
        let defaultTitle = String(format: "memoEdit.newMemoTitle".localized, String(memo.id))
        memoTitlePlaceholder.onNext(defaultTitle)
    }
    
    func makeCurrentResponderFirst() {
        if let responder = currentResponder {
            responder.paste(UIPasteboard.general.string)
            memo.save()
        }
    }
    
    func addTextEntry() {
        addMemoEntry(entry: memo.generateNewMemoEntry(with: .text))
    }

    func addLocationEntry() {
        addMemoEntry(entry: memo.generateNewMemoEntry(with: .location))
    }

    func addLinkEntry() {
        addMemoEntry(entry: memo.generateNewMemoEntry(with: .link))
    }

    func addPhotoEntry(image: UIImage) {
        let imageEntry = MemoImageEntry.imageEntry(with: image, memo: memo)
        if memo.entriesCount > 0, let imageCollection = memo.lastEntry as? MemoImageCollectionEntry {
            imageCollection.addEntry(imageEntry: imageEntry)
        } else {
            let imageCollection = memo.generateNewMemoEntry(with: .imageCollection) as! MemoImageCollectionEntry
            imageCollection.addEntry(imageEntry: imageEntry)
            memo.addEntry(entry: imageCollection)
        }
        imageEntry.save()
        applyNewEntries()
    }
    
    func removeMemo() {
        let message = String(format: "memos.deleteItemConfirmText".localized, memo.shortifiedTitle)
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
        memo.addEntry(entry: entry)
        focusOnEntry = entry
        applyNewEntries()
        save()
    }
    
    func removeImageEntry(imageEntry: MemoImageEntry) {
        showOkCancelAlert(message: "memoEdit.confirmImageDeletion".localized, okTitle: "common.delete".localized, inController: nil) {
            self.removeEntry(entry: imageEntry)
        } cancelComplete: {
        }
    }

    func removeEntry(at index: Int) {
        if index < memo.entriesCount {
            let entry = memo.entries[index]
            showOkCancelAlert(message: "memoEdit.confirmEntryDeletion".localized, okTitle: "common.delete".localized, inController: nil) {
                self.removeEntry(entry: entry)
            } cancelComplete: {
            }
        }
    }

    func removeEntry(entry: MemoEntry) {
        memo.removeEntry(entry: entry)
        applyNewEntries()
        save()
    }

    private func applyNewEntries() {
        var newEntries = [MemoEntry]()
        newEntries.append(contentsOf: memo.entries)
        acceptDataSource(newEntries)
        entriesCount.onNext(newEntries.count)
    }
    
    private func acceptDataSource(_ entries: [MemoEntry]) {
        dataSource.accept(entries)
    }
    
    func applyMemoTitle(title: String?) {
        if let title = title {
            memo.title = title
        } else {
            memo.title = ""
        }
    }
    
    func preloadEntryData(entry: MemoEntry) {
        dataProvider.preloadMemoEntry(entry: entry)
    }

    func save() {
        if self.memo.needToSave {
            self.memo.save()
        }
    }
}
