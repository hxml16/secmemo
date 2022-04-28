//
//  ImageCollectionCell.swift
//  secmemo
//
//  Created by heximal on 13.03.2022.
//

import Foundation
import UIKit
import RxSwift

class MemoImageCell: UICollectionViewCell {
    @IBOutlet weak var thumnbailImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    var disposeBag = DisposeBag()
    var onDeleteRequested: ((MemoImageEntry) -> ())?
    
    weak var entry: MemoImageEntry? {
        didSet {
            updateUI()
            setupBindings()
        }
    }
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        deleteButton.rx.tap
            .bind { [weak self] in
                if let entry = self?.entry {
                    self?.onDeleteRequested?(entry)
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func updateUI() {
        entry?.loadThumbnail(onComplete: { image in
            if let image = image {
                self.thumnbailImage.image = image
            } else {
                self.thumnbailImage.image = UIImage.broken
            }
        })
    }    
}
