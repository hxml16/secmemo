//
//  MemoLocationTableViewCellViewModel.swift
//  secmemo
//
//  Created by heximal on 02.03.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MemoLocationTableViewCellViewModel {
    let validatedCoordinate = PublishSubject<CLLocationCoordinate2D>()
    let validationState = BehaviorSubject<CoordValidationState>(value: .placeholder)
    private var _validationState = CoordValidationState.placeholder {
        didSet {
            validationState.onNext(_validationState)
        }
    }
    
    func validateCoordString(coordsString: String?) {
        guard let coordsString = coordsString, coordsString != "" else {
            _validationState = .placeholder
            return
        }
        if let coord = LocationUtils.parseCoordString(coordsString) {
            _validationState = .validated
            validatedCoordinate.onNext(coord)
        } else {
            _validationState = .invalid
        }
    }
    
    func applyCoordinate(coordinate: CLLocationCoordinate2D) {
        validatedCoordinate.onNext(coordinate)
        _validationState = .validated
    }
}
