//
//  EditMemoTableCellsFactory.swift
//  secmemo
//
//  Created by heximal on 27.02.2022.
//

import Foundation
import UIKit

class EditMemoTableCellsFactory {
    enum Constants {
        static let memoLocationTableViewCellIdentifier = "MemoLocationTableViewCell"
        static let memoTextEntryTableViewCellIdentifier = "MemoTextEntryTableViewCell"
        static let memoImageCollectionEntryTableViewCellIdentifier = "MemoImageCollectionCell"
        static let memoImageCellIdentifier = "MemoImageCell"
    }

    static func locationCell(tableView: UITableView, row: Int, item: MemoLocationEntry) -> MemoLocationTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.memoLocationTableViewCellIdentifier, for: IndexPath.init(row: row, section: 0)) as! MemoLocationTableViewCell
        cell.entry = item
        return cell
    }

    static func textCell(tableView: UITableView, row: Int, item: MemoTextEntry) -> MemoTextEntryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.memoTextEntryTableViewCellIdentifier, for: IndexPath.init(row: row, section: 0)) as! MemoTextEntryTableViewCell
        cell.entry = item
        return cell
    }

    static func imageCollectionCell(tableView: UITableView, row: Int, item: MemoImageCollectionEntry) -> MemoImageCollectionCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.memoImageCollectionEntryTableViewCellIdentifier, for: IndexPath.init(row: row, section: 0)) as! MemoImageCollectionCell
        cell.entry = item
        return cell
    }

    static func imageCell(collectionView: UICollectionView, row: Int, item: MemoImageEntry) -> MemoImageCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.memoImageCellIdentifier, for: IndexPath.init(row: row, section: 0)) as! MemoImageCell
        cell.entry = item
        return cell
    }
}
