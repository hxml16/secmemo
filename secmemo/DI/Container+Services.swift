//
//  Container+Services.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(SettingsService.self, initializer: SettingsServiceImpl.init).inObjectScope(.container)
        autoregister(SessionService.self, initializer: SessionServiceImpl.init).inObjectScope(.container)
        autoregister(KeyChainStorage.self, initializer: KeyChainStorage.init).inObjectScope(.container)
        autoregister(UserDefaultsStorage.self, initializer: UserDefaultsStorage.init).inObjectScope(.container)
        autoregister(LocationService.self, initializer: CoreLocationService.init).inObjectScope(.container)
        autoregister(FileStorageImpl.self, initializer: FileStorageImpl.init).inObjectScope(.container)
        autoregister(DataProvider.self, initializer: DataProviderImpl.init).inObjectScope(.container)
        autoregister(AutoLockServiceImpl.self, initializer: AutoLockServiceImpl.init).inObjectScope(.container)
    }
}
