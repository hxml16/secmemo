//
//  MemoLinkTableViewCellViewModel.swift
//  secmemo
//
//  Created by heximal on 02.03.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MemoLinkTableViewCellViewModel {
    let validatedHyperlink = PublishSubject<String>()
    let validationState = BehaviorSubject<ValidationState>(value: .placeholder)
    private var _validationState = ValidationState.placeholder {
        didSet {
            validationState.onNext(_validationState)
        }
    }
    
    func validateLinkString(linkString: String?) {
        guard let linkString = linkString, linkString != "" else {
            _validationState = .placeholder
            return
        }
        if linkString.isHyperlink {
            _validationState = .validated
            validatedHyperlink.onNext(linkString)
        } else {
            _validationState = .invalid
        }
    }
}
