//
//  PincodeCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

class PincodeCoordinator: BaseCoordinator {
    var viewModel: PincodeViewModel?
    var sessionService: SessionService
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    override func start() {
        let viewController = PincodeViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.presentOnTop(viewController, animated: true)
    }
}
