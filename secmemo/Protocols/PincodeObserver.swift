//
//  PincodeObserver.swift
//  secmemo
//
//  Created by heximal on 11.02.2022.
//

import Foundation

protocol PincodeObserver {
    func didCompletePincodeInput(pincodeApplied: Bool)
}
