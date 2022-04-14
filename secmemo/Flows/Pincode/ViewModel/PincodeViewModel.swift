//
//  PincodeViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

class PincodeViewModel {
    enum Constants {
        static let clearDotsDelayInterval: TimeInterval = 0.5
    }
    private var typingPincode = ""
    private var typedPincode = ""
    private let filledDotColor = Colors.primaryText.color
    private var pincodeMode = PincodeMode.unlock
    private var sessionService: SessionService
    private var pinPadEnabled = true
    
    let didValidatePincode = PublishSubject<Bool>()
    let dotsBackground = [
        clearColorBehviourSubject(),
        clearColorBehviourSubject(),
        clearColorBehviourSubject(),
        clearColorBehviourSubject()
    ]
    let didTypePincodeOnce = PublishSubject<Void>()
    let didCreatePincode = PublishSubject<Void>()
    let didCompletePincodeInputWithResult = PublishSubject<Bool>()
    let didCompletePincodeInput = PublishSubject<Void>()
    let pincodeTitle = BehaviorSubject<String>(value: "")
    let errorMessageToAlert = PublishSubject<String>()
    let cancelButtonAvailable = BehaviorSubject<Bool>(value: false)

    init (pincodeMode: PincodeMode, sessionService: SessionService) {
        self.pincodeMode = pincodeMode
        self.sessionService = sessionService
        cancelButtonAvailable.onNext(pincodeMode != .unlock)
        updateTitle()
    }
    
    func deleteLastSymbol() {
        if typingPincode == ""  || !pinPadEnabled {
            return
        }
        typingPincode = String(typingPincode[..<typingPincode.index(typingPincode.endIndex, offsetBy: -1)])
        updateDotsState()
    }
    
    private static func clearColorBehviourSubject() -> BehaviorSubject<UIColor> {
        return BehaviorSubject<UIColor>(value: .clear)
    }
    
    func completePincodeInput() {
        switch pincodeMode {
            case .repeatSecurity:
                notifyDidCompletePincodeInput()
            
            case .repeatEmergency:
                notifyDidCompletePincodeInput()
                sessionService.unlockSessionIfRequired()
            
            case .unlock:
                sessionService.unlockSessionIfRequired()
            
            case .changeSecurity, .changeEmergency:
                switchPincodeToSetup()

            default:
                break
        }
    }
    
    func notifyDidCompletePincodeInput() {
        didCompletePincodeInput.onNext(Void())
        didCompletePincodeInputWithResult.onNext(true)
    }
    
    func cancelPincodeInput() {
        didCompletePincodeInputWithResult.onNext(false)
    }
    
    func digitButtonTapped(tappedDigit: Int) {
        if !pinPadEnabled {
            return
        }
        typingPincode += String(tappedDigit)
        updateDotsState()
        if typingPincode.count >= dotsBackground.count {
            validatePincode()
        }
    }
    
    private func updateTitle() {
        let titleLzCode = pincodeMode.lzTitleCode
        pincodeTitle.onNext(titleLzCode.localized)
    }
    
    private func updateDotsState() {
        if dotsBackground.count <= 0 {
            return
        }
        
        for n in 0 ... dotsBackground.count - 1 {
            let color = n < typingPincode.count ? filledDotColor : UIColor.clear
            dotsBackground[n].onNext(color)
        }
    }
    
    private func validatePincode() {
        switch pincodeMode {
            case .unlock, .changeSecurity, .changeEmergency:
                typedPincode = typingPincode
                validatePincodeUnlock()
                
            case .setupSecurity, .setupEmergency:
                switchPincodeToRepeat()
                
            case .repeatSecurity, .repeatEmergency:
                validatePincodeRepeat()
            default:
                break
        }
    }
    
    private func validatePincodeUnlock() {
        let securityPincodeValid = typedPincode == sessionService.securityPincode
        let emergencyPincodeValid = typedPincode == sessionService.emergencyPincode
        var pincodeValid = securityPincodeValid || emergencyPincodeValid
        if emergencyPincodeValid {
            sessionService.didInputEmergencyPincode { emergencyPincodeConfirmed in
                pincodeValid = emergencyPincodeConfirmed
            }
        }
        if !pincodeValid {
            typingPincode = ""
            typedPincode = ""
            pinPadEnabled = false
            clearDotsAfterDelay(timeInterval: Constants.clearDotsDelayInterval)
        }
        didValidatePincode.onNext(pincodeValid)
    }

    private func validatePincodeRepeat() {
        if typedPincode != typingPincode {
            switchPincodeToSetup()
            errorMessageToAlert.onNext("pinCode.pincodesMismatchTitle".localized)
            return
        }
        switch pincodeMode {
            case .repeatSecurity:
                sessionService.securityPincode = typingPincode
            case .repeatEmergency:
                sessionService.emergencyPincode = typingPincode
            default:
                break
        }

        didCreatePincode.onNext(Void())
    }
    
    private func pincodesMatch(_ pincode1: String?, _ pincode2: String?) -> Bool {
        return pincode1 == pincode2
    }

    private func switchPincodeToSetup() {
        typedPincode = typingPincode
        typingPincode = ""
        didTypePincodeOnce.onNext(Void())
        switch pincodeMode {
            case .repeatSecurity, .changeSecurity:
                pincodeMode = .setupSecurity
            
            case .repeatEmergency, .changeEmergency:
                pincodeMode = .setupEmergency
            default:
                break
        }

        updateTitle()
    }

    private func switchPincodeToRepeat() {
        typedPincode = typingPincode
        typingPincode = ""
        didTypePincodeOnce.onNext(Void())
        switch pincodeMode {
            case .setupSecurity:
                pincodeMode = .repeatSecurity
            case .setupEmergency:
            if pincodesMatch(sessionService.securityPincode, typedPincode) {
                errorMessageToAlert.onNext("pinCode.pincodesMatch".localized)
                typedPincode = ""
                updateDotsState()
                return
            }
                pincodeMode = .repeatEmergency
            default:
                break
        }

        updateTitle()
    }

    private func clearDotsAfterDelay(timeInterval: TimeInterval) {
        executeOnMainThread(timeInterval) {
            self.pinPadEnabled = true
            self.updateDotsState()
        }
    }
}
