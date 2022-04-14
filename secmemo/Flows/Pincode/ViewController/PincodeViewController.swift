//
//  PincodeViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: Declarations and life cycle
class PincodeViewController: UIViewController, Storyboarded {
    deinit {
        print("deinit PincodeViewController")
    }
    struct Constants {
        static let quakeShiftsSequence: [CGFloat] = [-30, 30, -20, 20, -10, 10, 0]
        static let dotsZoomInScale: CGFloat = 0.7
        static let dotsZoomOutScale: CGFloat = 1.0
        static let dotsQuakeDuration: CGFloat = 0.6
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dotsContainer: UIView!
    @IBOutlet weak var dotsContainerCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var dots: [UIView]!

    static var storyboard = AppStoryboard.pincode
    private let disposeBag = DisposeBag()
    var viewModel: PincodeViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
extension PincodeViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        for button in digitButtons {
            button.rx.tap
                .bind { [weak self] in self?.viewModel?.digitButtonTapped(tappedDigit: button.tag) }
                .disposed(by: disposeBag)
        }
        
        for dot in dots {
            if dot.tag < viewModel.dotsBackground.count {
                viewModel.dotsBackground[dot.tag]
                    .subscribe(onNext: { color in
                        dot.backgroundColor = color
                    })
                    .disposed(by: disposeBag)
            }
        }
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.cancelPincodeInput()
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.cancelButtonAvailable
            .map{ !$0 }
            .bind(to: cancelButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.pincodeTitle
            .subscribe(onNext: { [weak self] title in
                self?.titleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessageToAlert
            .subscribe(onNext: { [weak self] errorMessageText in
                if let strongSelf = self {
                    showOkAlert(title: "common.error".localized, message: errorMessageText, inController: strongSelf)
                }
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { viewModel.deleteLastSymbol() }
            .disposed(by: disposeBag)
        
        viewModel.didTypePincodeOnce
            .subscribe(onNext: { [weak self] in self?.animateDotsReset() })
            .disposed(by: disposeBag)

        viewModel.didValidatePincode
            .subscribe ( onNext: { [weak self] isValid in
                if isValid {
                    viewModel.completePincodeInput()
                } else {
                    self?.animateDotsQuake(duration: PincodeViewModel.Constants.clearDotsDelayInterval)
                }
            })
            .disposed(by: disposeBag)

        viewModel.didCreatePincode
            .subscribe ( onNext: { [weak self] in
                if let strongSelf = self {
                    showOkAlert(title: "common.success".localized, message: "pinCode.pincodesCreatedTitle".localized, inController: strongSelf) {
                        strongSelf.dismiss(animated: true) {                            viewModel.completePincodeInput()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.didCompletePincodeInputWithResult
            .subscribe ( onNext: { [weak self] pincodeApplied in
                if pincodeApplied {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: UI Helpers
extension PincodeViewController {
    private func animateDotsQuake(duration: TimeInterval) {        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                animation.duration = duration
                animation.values = Constants.quakeShiftsSequence
                dotsContainer.layer.add(animation, forKey: "shake")
    }
    
    private func animateDotsReset() {
        let halfBlinkDuration: TimeInterval = 0.15
        var n: TimeInterval = 0.0
        for dot in dots {
            executeWithDelay(n * halfBlinkDuration) {
                UIView.animate(withDuration: halfBlinkDuration) {
                    dot.alpha = 0
                    dot.transform = CGAffineTransform(scaleX: Constants.dotsZoomInScale, y:  Constants.dotsZoomInScale)
                } completion: { b in
                    dot.backgroundColor = .clear
                    executeWithDelay(n * halfBlinkDuration) {
                        UIView.animate(withDuration: halfBlinkDuration) {
                            dot.alpha = 1
                            dot.transform = CGAffineTransform(scaleX: Constants.dotsZoomOutScale, y:   Constants.dotsZoomOutScale)
                        }
                    }
                }
            }
            n += halfBlinkDuration
        }
    }
}
