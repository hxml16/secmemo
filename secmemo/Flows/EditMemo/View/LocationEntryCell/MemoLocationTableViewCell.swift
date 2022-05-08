//
//  MemoLocationTableViewCell.swift
//  secmemo
//
//  Created by heximal on 19.02.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MemoLocationTableViewCell: UITableViewCell, FocusableEntryCell {
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var validationView: ValidationView!
    @IBOutlet weak var locationTextField: TextField!
    @IBOutlet weak var activityIndicator: CircleButtonActivityIndicator!
    @IBOutlet weak var actionListButton: UIButton!

    var focusableView: UIView? {
        return locationTextField
    }
    
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
        updateLocationTextField()
    }
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        myLocationButton.rx.tap
            .bind { [weak self] in
                self?.fetchCurrentLocationViaIsSetCheck()
            }
            .disposed(by: disposeBag)

        locationTextField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.actionListButton.visible = false
                self?.myLocationButton.visible = true
                self?.activityIndicator.visible = false
            })
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
                self?.actionListButton.visible = state.isValid
                self?.myLocationButton.visible = !state.isValid
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

        validationView.onOpenRequested = { [weak self] in
            self?.openLocation()
        }
        
        actionListButton.rx.tap
            .bind { [weak self] in
                self?.openLocation()
            }
            .disposed(by: disposeBag)

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
        entry?.save()
    }
    
    private func updateLocationTextField() {
        locationTextField.text = entry?.text
        viewModel.validateCoordString(coordsString: locationTextField.text)
    }
}
