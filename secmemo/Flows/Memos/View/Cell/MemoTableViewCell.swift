//
//  MemoTableViewCell.swift
//  RxTableViewOne
//
//  Created by Mahdi Mahjoobe on 12/10/18.
//  Copyright © 2018 Mahdi Mahjoobe. All rights reserved.
//

import UIKit
import RxSwift

class MemoTableViewCell: UITableViewCell {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabell: UILabel!
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImg.image = UIImage(named: "document")
        setupBindings()
    }
    
    var memoHeader: MemoHeader? {
        didSet {
            setMemoData()
        }
    }

    private func setMemoData() {
        if let title = memoHeader?.title, title != "" {
            titleLabel.text = memoHeader?.title
        } else if let memoHeader = memoHeader {
            titleLabel.text = String(format: "memoEdit.newMemoTitle".localized, String(memoHeader.id))
        }
        lastUpdatedLabell.text = memoHeader?.updatedAt.fullTimeStampFormatter
        let selectionColor = UIView()
        selectionColor.backgroundColor = Colors.memoTableSelectedBackgroundColor.color
        self.selectedBackgroundView = selectionColor
    }
    
    private func setupBindings() {
        let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
        dataProvider.onMemoHeaderChanged
            .subscribe(onNext: { [weak self] header in
                self?.applyNewHeaderIfRequired(header: header)
            })
            .disposed(by: disposeBag)
    }
    
    private func applyNewHeaderIfRequired(header: MemoHeader) {
        if let currentMemoHeader = memoHeader, header.id == currentMemoHeader.id {
            memoHeader = header
        }
    }
}
