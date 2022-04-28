//
//  PincodeCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

class PincodeCoordinator: BaseCoordinator {
    var viewModel: PincodeViewModel?
    var sessionService: SessionService
    var window: UIWindow?
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    override func start() {
        let viewController = PincodeViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        if let hostNavigationController = window?.rootViewController as? UINavigationController {
            navigationController = hostNavigationController
            navigationController.isNavigationBarHidden = true
            navigationController.navigationBar.isHidden = true
            presentPincodeControllerIfRequired(pincodeViewController: viewController, atTop: navigationController)
        } else if let hostViewController = window?.rootViewController {
            presentPincodeControllerIfRequired(pincodeViewController: viewController, atTop: hostViewController)
        } else if let window = window {
            ViewControllerUtils.setRootViewController (
                window: window,
                viewController: viewController,
                withAnimation: false)
        }
    }
    
    private func presentPincodeControllerIfRequired(pincodeViewController: UIViewController, atTop ofController: UIViewController) {
        // Prevents cycling pincodeController presentation over itself
        guard let _ = ofController.topViewController() as? PincodeViewController else {
            ofController.presentOnTop(pincodeViewController, animated: false)
            return
        }
    }
}
