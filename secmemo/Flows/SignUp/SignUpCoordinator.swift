//
//  SignUpCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

//MARK: Declarations and coordinator methods
class SignUpCoordinator: BaseCoordinator {
    var viewModel: SignUpViewModel?
    
    override func start() {
        let viewController = SignUpViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }
}
