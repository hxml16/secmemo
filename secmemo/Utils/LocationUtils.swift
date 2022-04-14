//
//  LocationUtils.swift
//  secmemo
//
//  Created by heximal on 09.03.2022.
//

import Foundation
import CoreLocation

class LocationUtils {
    static func parseCoordString(_ coordsString: String?) -> CLLocationCoordinate2D? {
        guard var coordsString = coordsString else {
            return nil
        }
        coordsString = coordsString.trimmingCharacters(in: .whitespacesAndNewlines)
        var latLngSplitted = coordsString.components(separatedBy: ",")
        if latLngSplitted.count != 2 {
            latLngSplitted = coordsString.components(separatedBy: " ")
            if latLngSplitted.count != 2 {
                return nil
            }
        }
        if latLngSplitted.count == 2 {
            let latStr = latLngSplitted[0].replacingOccurrences(of: ",", with: ".").trimmed
            let lngStr = latLngSplitted[1].replacingOccurrences(of: ",", with: ".").trimmed
            if let lat = latStr.floatValue, let lng = lngStr.floatValue, isValidCooridate(lat: lat, lng: lng) {
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            }
        }
        return nil
    }
    
    private static func isValidCooridate(lat: Float, lng: Float) -> Bool {
        return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180
    }
}
