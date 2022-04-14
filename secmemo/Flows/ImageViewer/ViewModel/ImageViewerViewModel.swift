//
//  EmptyViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

class ImageViewerViewModel {
    var imageCollection: MemoImageEntryDataSource
    let dataSource = BehaviorRelay<[MemoImageEntry]>(value: [])
    let selectedImageIndex = BehaviorSubject<Int>(value: 0)
    let titleBarText = BehaviorSubject<String>(value: "")
    
    private var currentImageIndex: Int = -1
    private let disposeBag = DisposeBag()

    init(imageCollection: MemoImageEntryDataSource) {
        self.imageCollection = imageCollection
        var newEntries = [MemoImageEntry]()
        newEntries.append(contentsOf: imageCollection.entries)
        dataSource.accept(newEntries)
        selectedImageIndex.onNext(imageCollection.selectedEntryIndex)
        updateTitleBarText(currentImageIndex: imageCollection.selectedEntryIndex)
    }
    
    func scrollToSelectedIndex() {
        selectedImageIndex.onNext(imageCollection.selectedEntryIndex)
    }

    func scrollToSelectedIndexIfRequired(itemsCollected: Int) {
        if itemsCollected > imageCollection.selectedEntryIndex {
            scrollToSelectedIndex()
        }
    }
    
    func imageSelected(imageIndex: Int) {
        if currentImageIndex != imageIndex {
            currentImageIndex = imageIndex
            updateTitleBarText(currentImageIndex: currentImageIndex)
        }
    }
    
    private func updateTitleBarText(currentImageIndex: Int) {
        let totalImageCount = imageCollection.entries.count
        let titleBarTextString = "\(currentImageIndex + 1) / \(totalImageCount)"
        titleBarText.onNext(titleBarTextString)
    }
}
