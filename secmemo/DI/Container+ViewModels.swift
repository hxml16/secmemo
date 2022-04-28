//
//  Container+ViewModels.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        autoregister(SignUpViewModel.self, initializer: SignUpViewModel.init)  
        autoregister(MemosViewModel.self, initializer: MemosViewModel.init)
        autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
    }
}
