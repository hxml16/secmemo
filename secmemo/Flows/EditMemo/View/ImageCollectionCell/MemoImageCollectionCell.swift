//
//  ImageCollectionCell.swift
//  secmemo
//
//  Created by heximal on 13.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MemoImageCollectionCell: UITableViewCell {
    enum Constants {
        static let collectionViewItemSize = CGSize(width: 96.0, height: 96.0)
    }
    @IBOutlet weak var collectionView: UICollectionView!

    var onDeleteRequested: ((MemoImageEntry) -> ())?
    var onImageViewerRequested: ((MemoImageEntry) -> ())?
    let dataSource = BehaviorRelay<[MemoImageEntry]>(value: [])
    let disposeBag = DisposeBag()
    
    var entry: MemoImageCollectionEntry? {
        didSet {
            var newEntries = [MemoImageEntry]()
            if let entry = entry {
                newEntries.append(contentsOf: entry.entries)
                dataSource.accept(newEntries)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: EditMemoTableCellsFactory.Constants.memoImageCellIdentifier, bundle: nil), forCellWithReuseIdentifier: EditMemoTableCellsFactory.Constants.memoImageCellIdentifier)
        setupBindings()
    }
    
    private func setupBindings() {
        collectionView.rx.observe(CGSize.self, "contentSize")
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] size in
                if let strongSelf = self {
                    if strongSelf.collectionView.contentSize.width > strongSelf.collectionView.bounds.size.width {
                        strongSelf.collectionView.setContentOffset(CGPoint(x: strongSelf.collectionView.contentSize.width - strongSelf.collectionView.bounds.size.width, y: 0), animated: false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        dataSource
            .bind(to: collectionView.rx.items) { [weak self]
              (collectionView: UICollectionView, row: Int, memoEntry: MemoImageEntry) in
                let imageCell = EditMemoTableCellsFactory.imageCell(collectionView: collectionView, row: row, item: memoEntry)
                imageCell.onDeleteRequested = { [weak self] imageEntry in
                    self?.onDeleteRequested?(imageEntry)
                }
                return imageCell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(MemoImageEntry.self).subscribe(onNext: { [weak self] imageEntry in
            self?.onImageViewerRequested?(imageEntry)
        }).disposed(by: disposeBag)
    }
}

extension MemoImageCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.collectionViewItemSize
    }
}
