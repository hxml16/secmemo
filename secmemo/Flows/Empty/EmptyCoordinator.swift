//
//  EmptyCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

//Flow template (not linked to target)
class EmptyCoordinator: BaseCoordinator {
    var viewModel: EmptyViewModel?
    
    override func start() {
        let viewController = EmptyViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }
}
