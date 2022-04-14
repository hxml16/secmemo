//
//  CLLocationCoordinate2D+Format.swift
//  secmemo
//
//  Created by heximal on 01.03.2022.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var formattedValue: String {
        return String(format: "%.5f", latitude) + ", " + String(format: "%.5f", longitude)
    }
}
