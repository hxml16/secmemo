//
//  ImageViewerViewCell.swift
//  secmemo
//
//  Created by heximal on 20.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

class ImageViewerViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let disposeBag = DisposeBag()
    var onContentOffsetChanged: ((CGPoint) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }

    var entry: MemoImageEntry? {
        didSet {
            updateUI()
        }
    }
    
    func resetScale() {
        scrollView.zoomScale = 1.0
    }
    
    private func setupBindings() {
        scrollView.rx.contentOffset
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] offset in
                  self?.notifyContentOffsetChanged(offset: offset)
            })
            .disposed(by: disposeBag)

    }
    
    private func updateUI() {
        entry?.loadOriginal(onComplete: { image in
            if let image = image {
                self.image.image = image
            } else {
                self.image.image = UIImage(named: "brokenImage")
            }
        })
    }
    
    private func notifyContentOffsetChanged(offset: CGPoint) {
        // if scrollView zoomScale is less than 1 then don't notify viewController
        // to avoid disappearing effect since it's not pull to dismiss gesture
        if scrollView.zoomScale > 0.999 {
            onContentOffsetChanged?(offset)
        }
    }
}

extension ImageViewerViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
}
