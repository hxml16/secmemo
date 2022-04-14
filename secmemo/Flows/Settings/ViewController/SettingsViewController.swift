//
//  SettingsViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class SettingsViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.settings
    @IBOutlet weak var clearAllDataButton: UIButton!
    @IBOutlet weak var changeSecurityPincodeButton: UIButton!
    @IBOutlet weak var changeEmergencyPincodeButton: UIButton!
    @IBOutlet weak var securityPincodeSwitch: UISwitch!
    @IBOutlet weak var emergencyPincodeSwitch: UISwitch!
    @IBOutlet weak var emergencySettingContainer: UIView!

    private let disposeBag = DisposeBag()
    var viewModel: SettingsViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

//MARK: Bindings
extension SettingsViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onConfirmAlertRequested = { [weak self] alertMessage, okButtonTitle, onAlertConfirmed, onAlertCancelled in
            if let strongSelf = self {
                showOkCancelAlert(message: alertMessage, okTitle: okButtonTitle, inController: strongSelf) {
                    onAlertConfirmed()
                } cancelComplete: {
                    onAlertCancelled()
                }
            }
        }

        clearAllDataButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.remeveAllData()
            }
            .disposed(by: disposeBag)
        
        changeSecurityPincodeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.changeSecurityPincode()
            }
            .disposed(by: disposeBag)

        changeEmergencyPincodeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.changeEmergencyPincode()
            }
            .disposed(by: disposeBag)

        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.securityPincodeEnabled
            .bind(to: securityPincodeSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.emergencyPincodeEnabled
            .bind(to: emergencyPincodeSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.securityPincodeEnabled
            .bind{ [weak self] isEnabled in
                self?.changeSecurityPincodeButton.visible = isEnabled
                self?.emergencySettingContainer.alpha = isEnabled ? Constants.opaqueAlphaValue : Constants.semitransparentAlphaValue
                self?.emergencySettingContainer.isUserInteractionEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        viewModel.emergencyPincodeEnabled
            .bind{ [weak self] isEnabled in
                self?.changeEmergencyPincodeButton.visible = isEnabled
            }
            .disposed(by: disposeBag)

        securityPincodeSwitch.rx.isOn
            .skip(1)
            .bind{ [weak self] isOn in
                self?.viewModel?.changeSecurityPincodeEnabledState(newState: isOn)
            }
            .disposed(by: self.disposeBag)
        
        emergencyPincodeSwitch.rx.isOn
            .skip(1)
            .bind{ [weak self] isOn in
                self?.viewModel?.changeEmergencyPincodeEnabledState(newState: isOn)
            }
            .disposed(by: self.disposeBag)
    }
}
