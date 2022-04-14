//
//  CoreLocationService.swift
//  secmemo
//
//  Created by heximal on 01.03.2022.
//

import Foundation
import CoreLocation
import RxCoreLocation
import RxSwift
import RxCocoa

class CoreLocationService: LocationService {
    enum Constants {
        static var locationChangedThreshold: CLLocationDegrees = 0.000001
    }
    
    var currentLocation: CLLocationCoordinate2D?
    var previousLocation: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    var onRequestLocationCompleteObservers = [OnRequestLocationComplete]()
    
    init() {
        checkAuthorizatrion()
    }
    
    func fetchCurrentLocation(onComplete: @escaping OnRequestLocationComplete) {
        onRequestLocationCompleteObservers.append(onComplete)
        checkAuthorizatrion()
    }
    
    private func checkAuthorizatrion() {
        initManager()
        locationManager.rx
                .isEnabled
                .debug("isEnabled")
                .subscribe(onNext: { [weak self] isEnabled in
                    if !isEnabled {
                        self?.notifyObserversServiceDisabled()
                        return
                    }
                    let status = CLLocationManager.authorizationStatus()
                    switch CLLocationManager.authorizationStatus() {
                        case .restricted, .denied:
                            self?.notifyObserversServiceDisabled()
                        case .authorizedAlways, .authorizedWhenInUse:
                            self?.startObservingLocationChange()
                        default:
                            break
                        
                    }
                })
                .disposed(by: disposeBag)
        
        locationManager.rx
            .didChangeAuthorization
            .subscribe(onNext: {[weak self] _, status in
                switch status {
                    case .restricted, .denied:
                        self?.notifyObserversServiceDisabled()
                    case .authorizedAlways, .authorizedWhenInUse:
                        self?.startObservingLocationChange()
                    default:
                        break
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func startObservingLocationChange() {
        locationManager.rx
            .location
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.currentLocation = location.coordinate
                if self?.isLocationChanged() == true {
                    self?.notifyObserversNewLocation(coordinate: location.coordinate)
                }
            })
            .disposed(by: disposeBag)
        locationManager.startUpdatingLocation()
    }
    
    private func isLocationChanged() -> Bool {
        guard let currentLocation = currentLocation, let previousLocation = previousLocation else {
            return true
        }
        let threshold = Constants.locationChangedThreshold
        return abs(currentLocation.latitude - previousLocation.latitude) > threshold ||
            abs(currentLocation.longitude - previousLocation.longitude) > threshold
    }

    private func initManager() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func notifyObserversServiceDisabled() {
        notifyObserversNewLocation(coordinate: nil)
    }

    private func notifyObserversNewLocation(coordinate: CLLocationCoordinate2D?) {
        for observer in onRequestLocationCompleteObservers {
            observer(coordinate)
        }
        onRequestLocationCompleteObservers = [OnRequestLocationComplete]()
    }
}
