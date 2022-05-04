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
    @IBOutlet weak var changeWrongAttemptsCountButton: UIButton!
    @IBOutlet weak var changeWrongAttemptsCountTitleLabel: UILabel!
    @IBOutlet weak var dismissPickerViewButton: UIButton!
    @IBOutlet weak var securityPincodeSwitch: UISwitch!
    @IBOutlet weak var emergencyPincodeSwitch: UISwitch!
    @IBOutlet weak var emergencySettingContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    weak var viewModel: SettingsViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        changeWrongAttemptsCountButton.rx.tap
            .bind { [weak self] in
                self?.showPickerView()
            }
            .disposed(by: disposeBag)

        dismissPickerViewButton.rx.tap
            .bind { [weak self] in
                self?.hidePickerView(animated: true)
            }
            .disposed(by: disposeBag)

        changeEmergencyPincodeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.changeEmergencyPincode()
            }
            .disposed(by: disposeBag)

        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismissController()
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
                self?.emergencySettingContainer.alpha = isEnabled ? GlobalConstants.opaqueAlphaValue : GlobalConstants.semitransparentAlphaValue
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
        
        viewModel.wrongAttemptsNumberSequenceObservable
                        .bind(to: pickerView.rx.itemTitles) { _, item in
                            return "\(item)"
                        }
                        .disposed(by: disposeBag)

        viewModel.numberOfWrongPincodeAttemptsTitle
            .bind{ [weak self] title in
                self?.changeWrongAttemptsCountButton.setTitle(title, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.numberOfWrongPincodeAttemptsValue
            .bind{ [weak self] value in
                self?.applyNumberOfWrongPincodeAttemptsValue(value: value)
            }
            .disposed(by: disposeBag)

        pickerView.rx.itemSelected
                        .subscribe(onNext: {[weak self] (row, value) in
                            self?.viewModel?.numberOfWrongPincodeAttempts = row
                        })
                        .disposed(by: disposeBag)
    }
}

//MARK: UI
extension SettingsViewController {
    private func setupUI() {
        hidePickerView(animated: false)
    }
    
    private func applyNumberOfWrongPincodeAttemptsValue(value: Int) {
        changeWrongAttemptsCountTitleLabel.alpha = value > 0 ? GlobalConstants.opaqueAlphaValue : GlobalConstants.semitransparentAlphaValue
        pickerView.selectRow(value, inComponent: 0, animated: false)
    }
    
    private func showPickerView() {
        pickerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: GlobalConstants.appearAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePickerView(animated: Bool) {
        pickerViewBottomConstraint.constant = -pickerViewHeightConstraint.constant
        if animated {
            UIView.animate(withDuration: GlobalConstants.appearAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func dismissController() {
        if let nc = navigationController {
            nc.dismiss(animated: true) {
                nc.viewControllers = []
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
