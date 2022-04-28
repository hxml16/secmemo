//
//  MemosCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import UIKit

//MARK: Declarations and coordinator methods
class MemosCoordinator: BaseCoordinator {
    var viewModel: MemosViewModel?
    var window: UIWindow?
    private lazy var editMemoViewModel = EditMemoViewModel(memo: Memo.empty)
    private let disposeBag = DisposeBag()
    private var dataProvider: DataProvider
    private var settingsService: SettingsService

    init(dataProvider: DataProvider, settingsService: SettingsService) {
        self.dataProvider = dataProvider
        self.settingsService = settingsService
    }
    
    override func start() {
        setupBindinds()
        startMemos()
    }
}

//MARK: Bindings
extension MemosCoordinator {
    private func setupBindinds() {
        viewModel?.didRequestEditDocument
            .subscribe(onNext: { [weak self] memo in
                self?.startEditMemo(memo: memo)
            })
            .disposed(by: disposeBag)

        viewModel?.didRequestSettings
            .subscribe(onNext: { [weak self] in
                self?.startSettings()
            })
            .disposed(by: disposeBag)
        
        dataProvider.onError
            .subscribe(onNext: { [weak self] error in
            self?.alert(error: error)
        })
        .disposed(by: disposeBag)

        viewModel?.onError
            .subscribe(onNext: { [weak self] error in
            self?.alert(error: error)
        })
        .disposed(by: disposeBag)
    }
}
 
//MARK: Routing
extension MemosCoordinator {
    private func startMemos() {
        guard let window = window else {
            return
        }
        var viewControllerToPresent: UIViewController?
        let memosViewController = MemosViewController.instantiate()
        memosViewController.viewModel = viewModel
        if UIDevice.isPad {
            let splitViewController = MemosMasterDetailsViewController.instantiate()
            let memoViewController = memoController(viewModel: editMemoViewModel)
            let memosNavigationController = UINavigationController(rootViewController:memosViewController)
            let memoNavigationController = UINavigationController(rootViewController:memoViewController)
                
            splitViewController.viewControllers = [memosNavigationController, memoNavigationController]
            viewControllerToPresent = splitViewController
        } else {
            navigationController.viewControllers = [memosViewController]
            navigationController.isNavigationBarHidden = false
            viewControllerToPresent = navigationController
        }
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: viewControllerToPresent!,
            withAnimation: false)
    }
    
    private func startEditMemo(memo: Memo) {
        startMemo(memo: memo)
    }

    private func startMemo(memo: Memo) {
        if UIDevice.isPad {
            editMemoViewModel.applyNewMemo(memo: memo)
        } else {
            let viewModel = EditMemoViewModel(memo: memo)
            let viewController = memoController(viewModel: viewModel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func memoController(viewModel: EditMemoViewModel) -> EditMemoViewController {
        let viewController = EditMemoViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.viewModel?.onImageViewerRequested
            .subscribe(onNext: { [weak self] imageCollection in
                self?.startImageViewer(imageCollection: imageCollection)
            })
            .disposed(by: disposeBag)
        return viewController
    }

    private func startSettings() {
        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(SettingsCoordinator.self)!
        coordinator.window = window
        start(coordinator: coordinator)
    }
    
    private func startImageViewer(imageCollection: MemoImageEntryDataSource) {
        let viewController = ImageViewerViewController.instantiate()
        viewController.viewModel = ImageViewerViewModel(imageCollection: imageCollection)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        window?.rootViewController?.present(viewController, animated: true)
    }
}

//MARK: Helper methods
extension MemosCoordinator {
    private func alert(error: Error) {
        showOkErrorAlert(message: error.localizedDescription, inController: topViewController)
    }
}
