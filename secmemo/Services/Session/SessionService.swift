//
//  SessionService.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

protocol SessionService {
    var didSignOut: PublishSubject<Void> { get }
    var didSignIn: PublishSubject<Void> { get }
    var didLock: PublishSubject<Void> { get }
    var didCleanupData: PublishSubject<Void> { get }
    var pincodesCreated: Bool { get set }
    var securityPincode: String? { get set }
    var emergencyPincode: String? { get set }

    func lockSessionIfRequired()
    func unlockSessionIfRequired()
    func forceUnlockSession()
    func didInputEmergencyPincode(confirmed: (Bool) -> ())
}
