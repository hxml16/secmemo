//
//  SessionServiceImpl.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

class SessionServiceImpl: SessionService {
    private var settingsService: SettingsService
    private var dataProvider: DataProvider
    let didSignOut = PublishSubject<Void>()
    let didSignIn = PublishSubject<Void>()
    
    let didLock = PublishSubject<Void>()
    let didSuspend = PublishSubject<Void>()
    
    let willLock = PublishSubject<Void>()
    let didUnlock = PublishSubject<Void>()
    let didCleanupData = PublishSubject<Void>()
    var sessionUnlocked = false
    var firstSessionUnlock = true

    func lockSessionIfRequired() {
        if settingsService.securityPincodeEnabled {
            sessionUnlocked = false
            willLock.onNext(Void())
            didLock.onNext(Void())
        }
        didSuspend.onNext(Void())
    }

    func unlockSessionIfRequired() {
        if settingsService.securityPincodeEnabled && !sessionUnlocked {
            if firstSessionUnlock {
                didSignIn.onNext(Void())
                firstSessionUnlock = false
            } else {
                didUnlock.onNext(Void())
            }
            sessionUnlocked = true
        }
        if !settingsService.securityPincodeEnabled {
            sessionUnlocked = true
        }
    }

    func forceUnlockSession() {
        sessionUnlocked = true
        didUnlock.onNext(Void())
    }

    init(settingService: SettingsService, dataProvider: DataProvider) {
        self.settingsService = settingService
        self.dataProvider = dataProvider
    }
    
    var pincodesCreated: Bool {
        get {
            return settingsService.pincodesCreated
        }
        
        set {
            settingsService.pincodesCreated = newValue
        }
    }
    
    var securityPincode: String? {
        get {
            return settingsService.securityPincode
        }

        set {
            settingsService.securityPincode = newValue
            settingsService.securityPincodeEnabled = PincodeUtils.isPincodeValid(newValue)
        }
    }

    var emergencyPincode: String? {
        get {
            return settingsService.emergencyPincode
        }

        set {
            settingsService.emergencyPincode = newValue
            settingsService.emergencyPincodeEnabled = PincodeUtils.isPincodeValid(newValue)
        }
    }
    
    func didInputEmergencyPincode(confirmed: (Bool) -> ()) {
        let emergencyPincodeConfirmed = settingsService.emergencyPincodeEnabled
        if emergencyPincodeConfirmed {
            firstSessionUnlock = true
            forceDataCleanup()
        }
        
        confirmed(emergencyPincodeConfirmed)
    }
    
    func forceDataCleanup() {
        dataProvider.cleanupAllData()
        didCleanupData.onNext(Void())
    }
}
