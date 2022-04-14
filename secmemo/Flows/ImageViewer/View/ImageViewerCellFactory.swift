//
//  ImageViewerCellFactory.swift
//  secmemo
//
//  Created by heximal on 20.03.2022.
//

import Foundation
import UIKit

class ImageViewerCellFactory {
    enum Constants {
        static let imageViewerViewCellIdentifier = "ImageViewerViewCell"
    }

    static func imageCell(collectionView: UICollectionView, row: Int, item: MemoImageEntry) -> ImageViewerViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageViewerViewCellIdentifier, for: IndexPath.init(row: row, section: 0)) as! ImageViewerViewCell
        cell.entry = item
        return cell
    }
}
