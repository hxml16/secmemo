//
//  MemoTextEntryTableViewCell.swift
//  secmemo
//
//  Created by heximal on 19.02.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MemoLocationTableViewCell: UITableViewCell {
    enum Constants {
        static let locationTextFieldHeightProportionToBadgeWidth: CGFloat = 0.8
    }
    
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var validationView: CoordValidationView!
    @IBOutlet weak var locationTextField: TextField!
    @IBOutlet weak var activityIndicator: CircleButtonActivityIndicator!

    private var disposeBag = DisposeBag()
    var onLocationUnavailable: (() -> ())?
    var onOpenLocation: ((MemoLocationEntry, UIView) -> ())?
    var onInvalidLocation: (() -> ())?
    private let viewModel = MemoLocationTableViewCellViewModel()

    override func prepareForReuse() {
        super.prepareForReuse()
        setupBindings()
    }

    var entry: MemoLocationEntry? {
        didSet {            
            updateUI()
            setupBindings()
        }
    }
    
    private func updateUI() {
//        disposeBag = DisposeBag()
        updateLocationTextField()
    }
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        myLocationButton.rx.tap
            .bind { [weak self] in
                self?.fetchCurrentLocationViaIsSetCheck()
            }
            .disposed(by: disposeBag)

        locationTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                if let strongSelf = self {
                    let locationStr = strongSelf.locationTextField.text
                    strongSelf.viewModel.validateCoordString(coordsString: locationStr)
                    strongSelf.entry?.text = locationStr
                    strongSelf.entry?.save()
                }
            })
            .disposed(by: disposeBag)

        viewModel.validationState
            .subscribe(onNext: { [weak self] state in
                self?.validationView.validationState = state
            })
            .disposed(by: disposeBag)

        viewModel.validatedCoordinate
            .subscribe(onNext: { [weak self] coordinate in
                self?.locationTextField.text = coordinate.formattedValue
            })
            .disposed(by: disposeBag)

        validationView.onInvalidAlertRequested = { [weak self] in
            self?.onInvalidLocation?()
        }

        validationView.onOpenLocationRequested = { [weak self] in
            self?.openLocation()
        }
    }
    
    private func openLocation() {
        if let locationEntry = entry {
            onOpenLocation?(locationEntry, self)
        }
    }

    private func fetchCurrentLocationViaIsSetCheck() {
        endEditing(true)
        guard let entry = entry else {
            return
        }
        if entry.isSet {
            showOkCancelAlert(message: "memoEdit.replaceCurrentLocation".localized, okTitle: "memoEdit.replaceButtonTitle".localized, inController: nil) {
                self.fetchCurrentLocation()
            } cancelComplete: {
            }

        } else {
            fetchCurrentLocation()
        }
    }

    private func fetchCurrentLocation() {
        activityIndicator.startAnimating()
        let locationService = AppDelegate.container.resolve(LocationService.self)!
        locationService.fetchCurrentLocation(onComplete: { [weak self] coordinate in
            self?.applyNewLocation(coordinate: coordinate)
        })
    }
    
    private func applyNewLocation(coordinate: CLLocationCoordinate2D?) {
        activityIndicator.stopAnimating()
        entry?.coordinate = coordinate
        if let coordinate = coordinate {
            viewModel.applyCoordinate(coordinate: coordinate)
        } else {
            onLocationUnavailable?()
        }
    }
    
    private func updateLocationTextField() {
        locationTextField.text = entry?.text
        viewModel.validateCoordString(coordsString: locationTextField.text)
    }
}
