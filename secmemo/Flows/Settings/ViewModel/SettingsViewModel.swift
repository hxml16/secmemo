//
//  SettingsViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import UIKit

typealias AlertConfirmed = (() -> ())

class SettingsViewModel {
    enum Constants {
        static let longHyphenSymbol = "—"
    }
    
    var settingsService: SettingsService
    let securityPincodeEnabled = BehaviorSubject<Bool>(value: false)
    let emergencyPincodeEnabled = BehaviorSubject<Bool>(value: false)
    let numberOfWrongPincodeAttemptsTitle = BehaviorSubject<String>(value: Constants.longHyphenSymbol)
    let numberOfWrongPincodeAttemptsValue = BehaviorSubject<Int>(value: 0)
    let wrongAttemptsNumberSequenceObservable = Observable.just(wrongAttemptsNumberSequence)
    var onConfirmAlertRequested: ((String, String,  @escaping AlertConfirmed, @escaping AlertConfirmed) -> ())?
    let didRequestPincode = PublishSubject<PincodeMode>()
    var currentRequestedPincode = PincodeMode.none
    
    var numberOfWrongPincodeAttempts: Int {
        get {
            return settingsService.numberOfWrongPincodeAttempts
        }
        
        set {
            settingsService.numberOfWrongPincodeAttempts = newValue
            numberOfWrongPincodeAttemptsTitle.onNext(SettingsViewModel.wrongAttemptsNumberStringValue(for: settingsService.numberOfWrongPincodeAttempts))
            numberOfWrongPincodeAttemptsValue.onNext(settingsService.numberOfWrongPincodeAttempts)
        }
    }
    
    static var wrongAttemptsNumberSequence = Array(0...GlobalConstants.wrongAttemptsNumberSequenceLength).map { wrongAttemptsNumberStringValue(for: $0) }
    
    static func wrongAttemptsNumberStringValue(for number: Int) -> String {
        return number == 0 ? Constants.longHyphenSymbol : String(number)
    }

    init (settingsService: SettingsService) {
        self.settingsService = settingsService
        securityPincodeEnabled.onNext(settingsService.securityPincodeEnabled)
        emergencyPincodeEnabled.onNext(settingsService.emergencyPincodeEnabled)
        numberOfWrongPincodeAttemptsTitle.onNext(SettingsViewModel.wrongAttemptsNumberStringValue(for: settingsService.numberOfWrongPincodeAttempts))
        numberOfWrongPincodeAttemptsValue.onNext(settingsService.numberOfWrongPincodeAttempts)
    }
    
    func remeveAllData() {
        onConfirmAlertRequested?("settings.clearAllDataConfirmTitle".localized, "common.delete".localized, {
            // OK case
            let dataProvider = AppDelegate.container.resolve(DataProvider.self)!
            dataProvider.cleanupAllData()
        }) {
            // Cancel case
        }
    }
    
    func changeSecurityPincode() {
        requestPinCode(with: .changeSecurity)
    }
    
    func changeEmergencyPincode() {
        requestPinCode(with: .changeEmergency)
    }

    func changeSecurityPincodeEnabledState(newState: Bool) {
        if newState {
            enableSecurityPincode()
        } else {
            disableSecurityPincode()
        }
    }
    
    func changeEmergencyPincodeEnabledState(newState: Bool) {
        if newState {
            enableEmergencyPincode()
        } else {
            disableEmergencyPincode()
        }
    }

    private func enableSecurityPincode() {
        requestPinCode(with: .setupSecurity)
    }
    
    private func disableSecurityPincode() {
        onConfirmAlertRequested?("settings.disableSecurityPincodeConfirmTitle".localized, "settings.disableButtonTitle".localized, {
            // OK case
            self.settingsService.securityPincode = nil
            self.settingsService.securityPincodeEnabled = false
            self.securityPincodeEnabled.onNext(false)            

            self.settingsService.emergencyPincodeEnabled = false
            self.settingsService.emergencyPincode = nil
            self.emergencyPincodeEnabled.onNext(false)
        }) {
            // Cancel case
            self.securityPincodeEnabled.onNext(true)
        }
    }

    private func enableEmergencyPincode() {
        requestPinCode(with: .setupEmergency)
    }
    
    private func disableEmergencyPincode() {
        onConfirmAlertRequested?("settings.disableEmergencyPincodeConfirmTitle".localized, "settings.disableButtonTitle".localized, {
            // OK case
            self.settingsService.emergencyPincode = nil
            self.settingsService.emergencyPincodeEnabled = false
            self.emergencyPincodeEnabled.onNext(false)
        }) {
            // Cancel case
            self.emergencyPincodeEnabled.onNext(true)
        }
    }
    
    private func requestPinCode(with pincodeMode: PincodeMode) {
        currentRequestedPincode = pincodeMode
        didRequestPincode.onNext(pincodeMode)
    }
}

//MARK: PincodeObserver
extension SettingsViewModel: PincodeObserver {
    func didCompletePincodeInput(pincodeApplied: Bool) {
        switch currentRequestedPincode {
            case .unlock:
                break
                
            case .setupSecurity:
                self.securityPincodeEnabled.onNext(self.settingsService.securityPincodeEnabled)
                
            case .setupEmergency:
                self.emergencyPincodeEnabled.onNext(self.settingsService.emergencyPincodeEnabled)
                
            case .repeatSecurity:
                break
                
            case .repeatEmergency:
                break
                
            default:
                break
        }
    }
}
