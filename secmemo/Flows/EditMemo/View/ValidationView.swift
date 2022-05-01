//
//  CoordValidationView.swift
//  secmemo
//
//  Created by heximal on 02.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ValidationState {
    case undefined
    case placeholder
    case invalid
    case validated
    
    var isValid: Bool {
        return self == .validated
    }
}

class ValidationView: UIView {
    @IBOutlet weak var invalidButton: UIButton!
    @IBOutlet weak var placeholderIcon: UIImageView!
    @IBOutlet weak var validatedIcon: UIImageView!
    @IBOutlet weak var openButton: UIButton!

    private var disposeBag = DisposeBag()
    var onInvalidAlertRequested: (() -> ())?
    var onOpenRequested: (() -> ())?
    var validationState = ValidationState.placeholder {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        setupBindings()
    }
    
    private func setupBindings() {
        openButton.rx.tap
            .bind { [weak self] in
                self?.onOpenRequested?()
            }
            .disposed(by: disposeBag)

        invalidButton.rx.tap
            .bind { [weak self] in
                self?.onInvalidAlertRequested?()
            }
            .disposed(by: disposeBag)
    }
    
    private func updateUI() {
        invalidButton.visible = false
        placeholderIcon.visible = false
        validatedIcon.visible = false
        switch validationState {
            case .placeholder:
                placeholderIcon.visible = true
            case .invalid:
                invalidButton.visible = true
            case .validated:
                validatedIcon.visible = true
            default:
                break
        }
        openButton.visible = !invalidButton.visible
    }
}
