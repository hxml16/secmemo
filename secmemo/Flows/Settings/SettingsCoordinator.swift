//
//  SettingsCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

class SettingsCoordinator: BaseCoordinator {
    var viewModel: SettingsViewModel?
    weak var window: UIWindow?
    
    private var settingsService: SettingsService
    private var sessionService: SessionService
    private let disposeBag = DisposeBag()

    init(settingsService: SettingsService, sessionService: SessionService) {
        self.settingsService = settingsService
        self.sessionService = sessionService
    }

    override func start() {
        let viewController = SettingsViewController.instantiate()
        
        let settingsViewModel = SettingsViewModel(settingsService: settingsService)
        settingsViewModel.didRequestPincode
            .subscribe ( onNext: { pincodeMode in
                self.showPincode(pincodeMode: pincodeMode, pincodeObserver: settingsViewModel)
            })
            .disposed(by: disposeBag)

        viewController.viewModel = settingsViewModel
        
        navigationController.viewControllers = [viewController]
        navigationController.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(navigationController, animated: true)
    }
}

//MARK: Routing
extension SettingsCoordinator {
    private func showPincode(pincodeMode: PincodeMode, pincodeObserver: PincodeObserver?) {
        let viewModel = PincodeViewModel(pincodeMode: pincodeMode, sessionService: sessionService, settingsService: settingsService)
        viewModel.didCompletePincodeInputWithResult
            .subscribe(onNext: { pincodeApplied in
                pincodeObserver?.didCompletePincodeInput(pincodeApplied: pincodeApplied)
            })
            .disposed(by: disposeBag)
        let viewController = PincodeViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.presentOnTop(viewController, animated: true)
    }
}
