//
//  EditMemoCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

class EditMemoCoordinator: BaseCoordinator {
    var viewModel: EditMemoViewModel?
    var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }

    override func start() {
        let viewController = EditMemoViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.locationService = locationService
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }
}
