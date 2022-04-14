//
//  MemoLocationEntry.swift
//  secmemo
//
//  Created by heximal on 17.02.2022.
//

import Foundation
import CoreLocation

class MemoLocationEntry: MemoTextEntry {
    var coordinate: CLLocationCoordinate2D? {
        get {
            guard let coordsString = text else {
                return nil
            }
            let parsedCoordintate = LocationUtils.parseCoordString(coordsString)
            return parsedCoordintate
        }
        
        set {
            self.text = newValue?.formattedValue
        }
    }
    
    var isSet: Bool {
        return coordinate != nil
    }
    
    override var type: MemoEntryType  {
        return MemoEntryType.location
    }
}
