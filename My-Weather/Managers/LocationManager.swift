//
//  LocationManager.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 9/2/2021.
//

import CoreLocation
import Foundation
import RxSwift

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    let psChangedAuthorization = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        self.locationManager.distanceFilter = 10
        self.locationManager.activityType = .other
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.delegate = self
    }
    
    func startTracking() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        } else {
            self.requestAuthorization()
        }
    }
    
    func stopTracking() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func enableBackgroundMode(_ bEnabled: Bool) {
        self.locationManager.allowsBackgroundLocationUpdates = bEnabled
    }
    
    func getCurrentLocation() -> CLLocation? {
        return self.currentLocation
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[LocationManager] didFailWithError \(error)")
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("[LocationManager] didUpdateLocations \(location) \(location.horizontalAccuracy)")
        if (location.horizontalAccuracy > 200) { return }
        self.currentLocation = locations.last
    }
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            self.psChangedAuthorization.onNext(())
        default:
            self.psChangedAuthorization.onNext(())
        }
    }
}
