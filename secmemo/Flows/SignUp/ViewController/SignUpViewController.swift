//
//  SignUpViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class SignUpViewController: UIViewController, Storyboarded {
    struct Constants {
        static let slideAnimationInterval: TimeInterval = 0.25
        static let welcomeLabelWidthToScreenAspect: CGFloat = 0.8
        static let welcomeLabelMaxWidth: CGFloat = 380
        static let welcomeLabelMinWidth: CGFloat = 288
    }

    static var storyboard = AppStoryboard.signUp
    @IBOutlet weak var setupSecurtityCodeButton: UIButton!
    @IBOutlet weak var setupEmergencyCodeButton: UIButton!
    @IBOutlet weak var skipEmergencyCodeButton: UIButton!
    @IBOutlet weak var emergencyAgreementSwitch: UISwitch!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageOneLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var welcomeLabelWidthConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel?
    
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
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       AppUtility.lockOrientation(.all)
   }
}
 
//MARK: Bindings
extension SignUpViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        setupSecurtityCodeButton.rx.tap
            .bind { viewModel.setupSecurityCode() }
            .disposed(by: disposeBag)

        setupEmergencyCodeButton.rx.tap
            .bind { viewModel.setupEmergencyCode() }
            .disposed(by: disposeBag)

        skipEmergencyCodeButton.rx.tap
            .bind { viewModel.completeSignUp() }
            .disposed(by: disposeBag)

        viewModel.isSetupEmergencyCodeActive
            .bind(to: setupEmergencyCodeButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.pageNumber
            .subscribe(onNext: { [weak self] newPageNumber in
                self?.animatePageSliding()
                self?.pageControl.currentPage = newPageNumber
            })
            .disposed(by: disposeBag)

        emergencyAgreementSwitch.rx.isOn
            .bind(to: setupEmergencyCodeButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}

//MARK: UI Helpers
extension SignUpViewController {
    private func animatePageSliding() {
        pageOneLeadingConstraint.constant = -UIScreen.main.bounds.size.width
        UIView.animate(withDuration: Constants.slideAnimationInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        pageOneLeadingConstraint.constant = 0.0
        welcomeLabelWidthConstraint.constant = self.view.frame.size.width * Constants.welcomeLabelWidthToScreenAspect
        if welcomeLabelWidthConstraint.constant > Constants.welcomeLabelMaxWidth {
            welcomeLabelWidthConstraint.constant = Constants.welcomeLabelMaxWidth
        }
        if welcomeLabelWidthConstraint.constant < Constants.welcomeLabelMinWidth {
            welcomeLabelWidthConstraint.constant = Constants.welcomeLabelMinWidth
        }
    }
}
