//
//  LocationService.swift
//  secmemo
//
//  Created by heximal on 01.03.2022.
//

import Foundation
import CoreLocation

typealias OnRequestLocationComplete = ((CLLocationCoordinate2D?) -> ())

protocol LocationService {
    func fetchCurrentLocation(onComplete: @escaping OnRequestLocationComplete)
}
