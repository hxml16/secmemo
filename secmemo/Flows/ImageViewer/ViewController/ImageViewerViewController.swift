//
//  EmptyViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class ImageViewerViewController: UIViewController, Storyboarded, UIScrollViewDelegate {
    enum Constants {
        // Y-scroll position after which controller begins to disappear
        static let alphaChangeContentOffsetThreshold: CGFloat = -10
        // Screen height percent after reqching contentOffset triggers
        static let controllerDimissOffsetRatio: CGFloat = 0.1
    }
    
    static var storyboard = AppStoryboard.imageViewer
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var titleBarLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private var collectionViewInitialized = false

    var viewModel: ImageViewerViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: ImageViewerCellFactory.Constants.imageViewerViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageViewerCellFactory.Constants.imageViewerViewCellIdentifier)
        setupBindings()
    }
}
    
//MARK: Bindings
extension ImageViewerViewController {
    private func setupBindings() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        guard let viewModel = viewModel else { return }
        
        viewModel.selectedImageIndex
            .subscribe(onNext: { [weak self] selectedImageIndex in
                self?.collectionView.contentOffset = CGPoint(x: self!.collectionView.frame.size.width * CGFloat(selectedImageIndex), y: 0)
            })
            .disposed(by: disposeBag)

        // Wait until layout creation is completed and then scroll to
        // image index selected by user
        collectionView.rx.observe(CGSize.self, "contentSize")
            .take(2)
            .subscribe(onNext: { [weak self] size in
                if let size = size, size.width > 0 {
                    self?.viewModel?.scrollToSelectedIndex()
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
         
        collectionView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    let imageIndex = Int(strongSelf.collectionView.contentOffset.x /  strongSelf.collectionView.frame.size.width)
                    strongSelf.viewModel?.imageSelected(imageIndex: imageIndex)
                }
            })
            .disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell
            .subscribe(onNext: { cell, at in
                if let imageCell = cell as? ImageViewerViewCell {
                    imageCell.resetScale()
                }
            })
            .disposed(by: disposeBag)

        viewModel.dataSource
            .bind(to: collectionView.rx.items) {
              (collectionView: UICollectionView, row: Int, memoEntry: MemoImageEntry) in
                let imageCell = ImageViewerCellFactory.imageCell(collectionView: collectionView, row: row, item: memoEntry)
                imageCell.onContentOffsetChanged = { [weak self] offset in
                    self?.imageCellContentOffsetChanged(to: offset)
                }
                imageCell.entry = memoEntry
                return imageCell
            }
            .disposed(by: disposeBag)
        
        viewModel.titleBarText
            .bind(to: titleBarLabel.rx.text)
            .disposed(by: disposeBag)

    }
}

//MARK: UI Helpers
extension ImageViewerViewController {
    func imageCellContentOffsetChanged(to offset: CGPoint) {
        if isBeingDismissed {
            return
        }
        let dismissThreshold = self.view.frame.size.height * -Constants.controllerDimissOffsetRatio
        if offset.y > Constants.alphaChangeContentOffsetThreshold {
            self.view.alpha = 1.0
            header.isHidden = false
        } else {
            let offsetRatio =  abs(offset.y / dismissThreshold) * 0.5
            self.view.alpha = 1.0 - offsetRatio
            header.isHidden = true
        }
        if offset.y < dismissThreshold {
            self.view.alpha = 0
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: UI Helpers
extension ImageViewerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
