//
//  BaseCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: NSObject, Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    var topViewController: UIViewController {
        if let topViewController = navigationController.viewControllers.last {
            return topViewController
        }
        return navigationController
    }
    
    var topCoordinator: BaseCoordinator {
        if childCoordinators.count > 0, let coordinator = childCoordinators.last as? BaseCoordinator {
            return coordinator
        } else {
            return self
        }
    }
    
    var topCoordinatorTopViewController: UIViewController {
        return topCoordinator.topViewController
    }
}
