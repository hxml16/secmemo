//
//  AutoLockServiceImpl.swift
//  secmemo
//
//  Created by heximal on 15.11.2024.
//
import RxSwift
import Foundation

class AutoLockServiceImpl: AutoLockService {
    private let disposeBag = DisposeBag()
    private let sessionService: SessionService
    private let settingsService: SettingsService
    private var timer: Timer?
    private var lastUnlockDate: Date?

    init (sessionService: SessionService, settingsService: SettingsService) {
        self.sessionService = sessionService
        self.settingsService = settingsService
        subscribeToSessionChanges()
        initTimer()
    }
    
    func resetUnlockDateIfRequired() {
        if lastUnlockDate != nil {
            lastUnlockDate = Date()
        }
    }
}

//MARK: Bindings
extension AutoLockServiceImpl {
    private func subscribeToSessionChanges() {
        sessionService.didSignIn
            .subscribe(onNext: { [weak self] in
                self?.lastUnlockDate = Date()
            })
            .disposed(by: disposeBag)

        sessionService.didLock
            .subscribe(onNext: { [weak self] in
                self?.lastUnlockDate = nil
            })
            .disposed(by: disposeBag)

        sessionService.didUnlock
            .subscribe(onNext: { [weak self] in
                self?.lastUnlockDate = Date()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: Private
extension AutoLockServiceImpl {
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0,
          target: self,
          selector: #selector(timerTick),
          userInfo: nil,
          repeats: true
        )
    }
    
    @objc
    private func timerTick() {
        if let lastUnlockDate, let autoLockTimeout = settingsService.autoLockTimeout, autoLockTimeout > 0 {
            let timeIntervalSinceLastUnlock = Date().timeIntervalSince(lastUnlockDate)
            if timeIntervalSinceLastUnlock > TimeInterval(autoLockTimeout) {
                sessionService.lockSessionIfRequired()
            }
        }
    }
}
