//
//  MemoLinkTableViewCell.swift
//  secmemo
//
//  Created by heximal on 19.02.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MemoLinkTableViewCell: UITableViewCell, FocusableEntryCell {
    @IBOutlet weak var validationView: ValidationView!
    @IBOutlet weak var linkTextField: TextField!
    @IBOutlet weak var actionListButton: UIButton!

    private var disposeBag = DisposeBag()
    var onOpenLink: ((MemoLinkEntry, UIView) -> ())?
    var onInvalidLink: (() -> ())?
    private let viewModel = MemoLinkTableViewCellViewModel()

    var focusableView: UIView? {
        return linkTextField
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        setupBindings()
    }

    var entry: MemoLinkEntry? {
        didSet {            
            updateUI()
            setupBindings()
        }
    }
    
    private func updateUI() {
        updateLinkTextField()
    }
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        linkTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                if let strongSelf = self {
                    let linkStr = strongSelf.linkTextField.text
                    strongSelf.viewModel.validateLinkString(linkString: linkStr)
                    strongSelf.entry?.text = linkStr
                    strongSelf.entry?.save()
                }
            })
            .disposed(by: disposeBag)

        viewModel.validationState
            .subscribe(onNext: { [weak self] state in
                self?.validationView.validationState = state
                self?.actionListButton.visible = state.isValid
            })
            .disposed(by: disposeBag)

        viewModel.validatedHyperlink
            .subscribe(onNext: { [weak self] link in
                self?.linkTextField.text = link
            })
            .disposed(by: disposeBag)

        validationView.onInvalidAlertRequested = { [weak self] in
            self?.onInvalidLink?()
        }

        validationView.onOpenRequested = { [weak self] in
            self?.openLink()
        }
        
        actionListButton.rx.tap
            .bind { [weak self] in
                self?.openLink()
            }
            .disposed(by: disposeBag)
    }
    
    private func openLink() {
        if let linkEntry = entry {
            onOpenLink?(linkEntry, self)
        }
    }

    private func updateLinkTextField() {
        linkTextField.text = entry?.text
        viewModel.validateLinkString(linkString: entry?.text)
    }
}
