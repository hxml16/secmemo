//
//  SignUpViewModel.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

class SignUpViewModel {
    struct Constants {
        static let signUpPagesCount: Int = 2
    }
    
    let didSignUp = PublishSubject<Void>()
    let didSkip = PublishSubject<Void>()
    let didRequestPincode = PublishSubject<PincodeMode>()
    let pageNumber = PublishSubject<Int>()

    private var sessionService: SessionService
    private var currentSignUpPage: Int = 0
    private var typedPincode = ""
    private let filledDotColor = Colors.primaryText.color
    let isSetupEmergencyCodeActive = BehaviorSubject<Bool>(value: false)
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }

    func setupSecurityCode() {
        didRequestPincode.onNext(.setupSecurity)
    }
    
    func setupEmergencyCode() {
        didRequestPincode.onNext(.setupEmergency)
    }

    func completeSignUp() {
        sessionService.forceUnlockSession()
        didSignUp.onNext(Void())
    }
}

//MARK: PincodeObserver
extension SignUpViewModel: PincodeObserver {
    func didCompletePincodeInput(pincodeApplied: Bool) {
        if !pincodeApplied {
            return
        }
        
        currentSignUpPage += 1
        if currentSignUpPage >= Constants.signUpPagesCount {
            completeSignUp()
        } else {
            pageNumber.onNext(currentSignUpPage)
            sessionService.pincodesCreated = true
        }
    }
}
