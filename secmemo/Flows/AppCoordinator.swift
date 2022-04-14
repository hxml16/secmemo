 //
//  AppCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

//MARK: Declarations and coordinator methods
class AppCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private let settingsService: SettingsService
    private let sessionService: SessionService
    private let memosViewModel: MemosViewModel
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    init(settingsService: SettingsService, sessionService: SessionService, memosViewModel: MemosViewModel) {
        self.settingsService = settingsService
        self.sessionService = sessionService
        self.memosViewModel = memosViewModel
    }
    
    override func start() {
        window.makeKeyAndVisible()
        
        subscribeToSessionChanges()
        if sessionService.pincodesCreated {
            if settingsService.securityPincodeEnabled || settingsService.emergencyPincodeEnabled {
                showSignIn()
            } else {
                sessionService.unlockSessionIfRequired()
                showMemos()
            }
        } else {
            showSignUp()
        }
    }
}

//MARK: Bindings
extension AppCoordinator {
    private func subscribeToSessionChanges() {
        sessionService.didSignIn
            .subscribe(onNext: { [weak self] in
                self?.showMemos()                
            })
            .disposed(by: disposeBag)
        
        sessionService.didLock
            .subscribe(onNext: { [weak self] in
                self?.showPincode(pincodeMode: .unlock, hostViewController: self?.topCoordinatorTopViewController, pincodeObserver: nil) })
            .disposed(by: disposeBag)
    }
}

//MARK: Routing
extension AppCoordinator {
    private func showPincode(pincodeMode: PincodeMode, hostViewController: UIViewController?, pincodeObserver: PincodeObserver?) {
        let coordinator = AppDelegate.container.resolve(PincodeCoordinator.self)!
        let viewModel = PincodeViewModel(pincodeMode: pincodeMode, sessionService: sessionService)
        viewModel.didCompletePincodeInput
            .subscribe(onNext: {
                pincodeObserver?.didCompletePincodeInput(pincodeApplied: true)
            })
            .disposed(by: disposeBag)
        coordinator.viewModel = viewModel
        if let hostNavigationController = hostViewController?.navigationController {
            coordinator.navigationController = hostNavigationController
        } else {
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: coordinator.navigationController,
                withAnimation: true)
        }
        coordinator.start()
    }
     
    private func showSignIn() {
        self.showPincode(pincodeMode: .unlock, hostViewController: nil, pincodeObserver: self)
    }
    
    private func showSignUp() {
        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(SignUpCoordinator.self)!
        let signUpViewModel = SignUpViewModel(sessionService: sessionService)
        signUpViewModel.didSignUp
            .subscribe(onNext: { [weak self] in self?.showMemos() })
            .disposed(by: disposeBag)
        signUpViewModel.didRequestPincode
            .subscribe ( onNext: { pincodeMode in
                self.showPincode(pincodeMode: pincodeMode, hostViewController: coordinator.topViewController, pincodeObserver: signUpViewModel)
            })
            .disposed(by: disposeBag)

        coordinator.viewModel = signUpViewModel
        
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
    
    private func showMemos() {
        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(MemosCoordinator.self)!
        coordinator.viewModel = memosViewModel
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
}

//MARK: PincodeObserver
extension AppCoordinator: PincodeObserver {
    func didCompletePincodeInput(pincodeApplied: Bool) {
        if pincodeApplied {
            showMemos()
        }
    }        
}
