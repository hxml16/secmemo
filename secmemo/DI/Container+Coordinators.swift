//
//  Container+Coordinators.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerCoordinators() {
        autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        autoregister(PincodeCoordinator.self, initializer: PincodeCoordinator.init)
        autoregister(SignUpCoordinator.self, initializer: SignUpCoordinator.init)
        autoregister(MemosCoordinator.self, initializer: MemosCoordinator.init)
        autoregister(SettingsCoordinator.self, initializer: SettingsCoordinator.init)
        autoregister(EditMemoCoordinator.self, initializer: EditMemoCoordinator.init)
    }
}
