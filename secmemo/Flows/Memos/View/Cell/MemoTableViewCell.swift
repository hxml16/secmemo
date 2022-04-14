//
//  MemoTableViewCell.swift
//  RxTableViewOne
//
//  Created by Mahdi Mahjoobe on 12/10/18.
//  Copyright © 2018 Mahdi Mahjoobe. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImg.image = UIImage(named: "document")
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
    }
}
