//
//  MemoImageEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation
import UIKit

class MemoImageEntry: MemoEntry {
    var hashThumbnail = UUID().uuidString

    private var _originalImage: UIImage?
    private var _thumbnailImage: UIImage?
    
    private var _originalImageEntry: MemoDataEntry?
    private var _thumbnailImageEntry: MemoDataEntry?
    
    var originalImage: UIImage? {
        return _originalImage
    }
    
    var thumbnailImage: UIImage? {
        return _thumbnailImage
    }
    
    override var dict: [String: Any] {
        var temp = super.dict
        temp["hashThumbnail"] = hashThumbnail
        return temp
    }
    
    override var type: MemoEntryType  {
        return .image
    }

    static func imageEntry(with dict: [String: Any], memoId: Int) -> MemoImageEntry? {
        if let _hash = dict["hash"] as? String , let _hashThumbnail = dict["hashThumbnail"] as? String {
            let entry = MemoImageEntry()
            entry.hashThumbnail = _hashThumbnail
            entry.hash = _hash
            return entry
        }
        return nil
    }

    static func imageEntry(with image: UIImage, memo: Memo) -> MemoImageEntry {
        let entry = MemoImageEntry()
        entry.isChanged = true
        entry.memoId = memo.id
        entry._originalImage = image
        entry._thumbnailImage = image.scale(to: Constants.imageEntryThumbnailSize)
        return entry
    }
    
    override func save() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        save(dataProvider: dataProvider)
    }
    
    func save(dataProvider: DataProvider) {
        if let _originalImage = _originalImage, let imageData = _originalImage.jpegData(compressionQuality: 0.75) {
            let dataEntry = MemoDataEntry(data: imageData, hash: hash, memoId: memoId)
            let _ = dataProvider.save(entry: dataEntry)
        }
        if let _thumbnailImage = _thumbnailImage, let imageData = _thumbnailImage.jpegData(compressionQuality: 0.75) {
            let dataEntry = MemoDataEntry(data: imageData, hash: hashThumbnail, memoId: memoId)
            let _ = dataProvider.save(entry: dataEntry)
        }
    }
    
    override func remove() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        let dataOriginalEntry = MemoDataEntry(data: Data(), hash: hash, memoId: memoId)
        let dataThumbnaillEntry = MemoDataEntry(data: Data(), hash: hashThumbnail, memoId: memoId)
        dataProvider.remove(entry: dataOriginalEntry)
        dataProvider.remove(entry: dataThumbnaillEntry)
    }

    
    func preloadImages(dataProvider: DataProvider) {
        loadImage(with: hashThumbnail, dataProvider: dataProvider) { image in
            self._thumbnailImage = image
        }
        loadImage(with: hash, dataProvider: dataProvider) { image in
            self._originalImage = image
        }
    }
    
    func loadThumbnail(onComplete: ((UIImage?) -> ())) {
        loadImage(with: hashThumbnail, onComplete: onComplete)
    }

    func loadOriginal(onComplete: ((UIImage?) -> ())) {
        loadImage(with: hash, onComplete: onComplete)
    }

    func loadImage(with dataHash: String, onComplete: ((UIImage?) -> ())) {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        loadImage(with: dataHash, dataProvider: dataProvider, onComplete: onComplete)
    }

    func loadImage(with dataHash: String, dataProvider: DataProvider, onComplete: ((UIImage?) -> ())) {
        let dataEntry = MemoDataEntry(data: Data(), hash: dataHash, memoId: memoId)
        dataProvider.preloadMemoEntry(entry: dataEntry)
        if let image = UIImage(data: dataEntry.data) {
            onComplete(image)
        } else {
            onComplete(nil)
        }
    }
}
