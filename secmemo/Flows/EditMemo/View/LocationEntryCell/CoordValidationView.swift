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

enum CoordValidationState {
    case undefined
    case placeholder
    case invalid
    case validated
}

class CoordValidationView: UIView {
    @IBOutlet weak var invalidButton: UIButton!
    @IBOutlet weak var locationPlaceholderIcon: UIImageView!
    @IBOutlet weak var locationValidatedIcon: UIImageView!
    @IBOutlet weak var openLocationButton: UIButton!

    private var disposeBag = DisposeBag()
    var onInvalidAlertRequested: (() -> ())?
    var onOpenLocationRequested: (() -> ())?
    var validationState = CoordValidationState.placeholder {
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
        openLocationButton.rx.tap
            .bind { [weak self] in
                self?.onOpenLocationRequested?()
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
        locationPlaceholderIcon.visible = false
        locationValidatedIcon.visible = false
        switch validationState {
            case .placeholder:
                locationPlaceholderIcon.visible = true
            case .invalid:
                invalidButton.visible = true
            case .validated:
                locationValidatedIcon.visible = true
            default:
                break
        }
        openLocationButton.visible = !invalidButton.visible
    }
}
