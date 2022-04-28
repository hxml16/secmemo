//
//  LocationUtils.swift
//  secmemo
//
//  Created by heximal on 09.03.2022.
//

import Foundation
import CoreLocation
import UIKit

class LocationUtils {
    // Returns array of map application avaliable on the device
    static func listOfAvailableMapApps(coordinate: CLLocationCoordinate2D) -> [(String, URL)] {
        let application = UIApplication.shared
        let coordinateString = coordinate.formattedValue.replacingOccurrences(of: " ", with: "")
        let coordinateStringReversed = "\(coordinate.longitude),\(coordinate.latitude)"
        let handlers = [
            ("Apple Maps", "http://maps.apple.com/?q=\(coordinateString)&ll=\(coordinateString)"),
            ("Google Maps", "comgooglemaps://?q=\(coordinateString)"),
            ("Maps.me", "mapswithme://map?v=1&ll=\(coordinateString)"),
            ("Yandex Maps", "yandexmaps://maps.yandex.com/?ll=\(coordinateStringReversed)"),
            ("Waze", "waze://?ll=\(coordinateString)"),
            ("Citymapper", "citymapper://directions?endcoord=\(coordinateString)&endname=\(coordinateString)")
        ]
            .compactMap { (name, address) in URL(string: address).map { (name, $0) } }
            .filter { (_, url) in application.canOpenURL(url) }
        return handlers
    }
    
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
