//
//  MemosCoordinator.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift

//MARK: Declarations and coordinator methods
class MemosCoordinator: BaseCoordinator {
    var viewModel: MemosViewModel?
    private let disposeBag = DisposeBag()
    private var dataProvider: DataProvider
    private var settingsService: SettingsService

    init(dataProvider: DataProvider, settingsService: SettingsService) {
        self.dataProvider = dataProvider
        self.settingsService = settingsService
    }
    
    override func start() {
        let viewController = MemosViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
        setupBindinds()
    }
}

//MARK: Bindings
extension MemosCoordinator {
    private func setupBindinds() {
        viewModel?.didRequestNewDocument
            .subscribe(onNext: { [weak self] in
                self?.startNewMemo()
            })
            .disposed(by: disposeBag)

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
    private func startNewMemo() {
        if let newMemo = dataProvider.generateNewMemo() {
            newMemo.save()
            startMemo(memo: newMemo)
        }
    }

    private func startEditMemo(memo: Memo) {
        startMemo(memo: memo)
    }

    private func startMemo(memo: Memo) {
        let viewController = EditMemoViewController.instantiate()
        viewController.viewModel = EditMemoViewModel(memo: memo)
        viewController.viewModel?.onImageViewerRequested
            .subscribe(onNext: { [weak self] imageCollection in
                self?.startImageViewer(imageCollection: imageCollection)
            })
            .disposed(by: disposeBag)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func startSettings() {
        removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(SettingsCoordinator.self)!
        start(coordinator: coordinator)
    }
    
    private func startImageViewer(imageCollection: MemoImageEntryDataSource) {
        let viewController = ImageViewerViewController.instantiate()
        viewController.viewModel = ImageViewerViewModel(imageCollection: imageCollection)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.topViewController?.present(viewController, animated: true)
    }
}

//MARK: Helper methods
extension MemosCoordinator {
    private func alert(error: Error) {
        showOkErrorAlert(message: error.localizedDescription, inController: topViewController)
    }
}
