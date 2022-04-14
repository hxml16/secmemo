//
//  Int+Extension.swift
//  secmemo
//
//  Created by heximal on 07.03.2022.
//

import Foundation
import RxSwift

extension Int {
    var fullTimeStampFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return dateFormatter.string(from: date)
    }
}
