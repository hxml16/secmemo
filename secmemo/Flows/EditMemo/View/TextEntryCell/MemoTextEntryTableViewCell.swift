//
//  MemoTextEntryTableViewCell.swift
//  secmemo
//
//  Created by heximal on 19.02.2022.
//

import Foundation
import RxSwift

class MemoTextEntryTableViewCell: MultiLineTextInputTableViewCell {
    @IBOutlet weak var textPlaceholder: UILabel!
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
        textPlaceholder.font = textView?.font
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupBindings()
    }

    var entry: MemoTextEntry? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        disposeBag = DisposeBag()
        textView?.text = entry?.text
        textPlaceholder.isHidden = entry?.text != nil && entry?.text != ""
        setupBindings()
    }
    
    func setupBindings() {
        textView?.rx.text.subscribe(onNext: { [weak self] text in
            self?.entry?.text = text
            self?.textPlaceholder.isHidden = text != ""
        }).disposed(by: disposeBag)
    }
}
