//
//  Container+RegisterDependencies.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Swinject

extension Container {
    func registerDependencies() {
        registerServices()
        registerCoordinators()
        registerViewModels()
    }
}
