//
//  LocationManager.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentCountry: String = "us" // Default to US
    @Published var currentCity: String?
    @Published var isLocationAvailable = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // Automatically request location without explicit user prompt
        requestLocationSilently()
    }
    
    private func requestLocationSilently() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // Use default location (US) without showing error
            isLocationAvailable = false
        @unknown default:
            isLocationAvailable = false
        }
    }
    
    func refreshLocation() {
        requestLocationSilently()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        currentLocation = location
        isLocationAvailable = true
        reverseGeocode(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Silently fail and use default location
        isLocationAvailable = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            isLocationAvailable = false
        default:
            break
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first else { return }
                
                self?.currentCity = placemark.locality
                
                // Map country codes to News API supported countries
                if let countryCode = placemark.isoCountryCode?.lowercased() {
                    self?.currentCountry = self?.mapCountryCode(countryCode) ?? "us"
                }
            }
        }
    }
    
    private func mapCountryCode(_ code: String) -> String {
        // News API supported countries
        let countryMap: [String: String] = [
            "us": "us", "gb": "gb", "ca": "ca", "au": "au",
            "de": "de", "fr": "fr", "it": "it", "jp": "jp",
            "kr": "kr", "cn": "cn", "in": "in", "br": "br",
            "mx": "mx", "ru": "ru", "eg": "eg", "za": "za",
            "ng": "ng", "ar": "ar", "nl": "nl", "be": "be",
            "ch": "ch", "at": "at", "se": "se", "no": "no",
            "dk": "dk", "fi": "fi", "ie": "ie", "pt": "pt",
            "es": "es", "gr": "gr", "tr": "tr", "il": "il",
            "sa": "sa", "ae": "ae", "th": "th", "sg": "sg",
            "my": "my", "ph": "ph", "id": "id", "vn": "vn"
        ]
        
        return countryMap[code] ?? "us"
    }
}
