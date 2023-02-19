//  LocationManager.swift
//  capstone-geography


import Foundation

import CoreLocation
import CoreLocationUI

import Foundation

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    //Interval to prevent overcalling the geolocate API
    let geolocationRateLimit = 10.0
    var lastGeolocationTime: TimeInterval = 0.0
    
    @Published var location: CLLocationCoordinate2D?
    @Published var address: String?
    @Published var distance: Int?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
        
        //Geolocate
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastGeolocationTime > geolocationRateLimit {
            lastGeolocationTime = currentTime
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location!.latitude, longitude: location!.longitude)) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    self.address = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? ""),\n\(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    //Distance between user and a location
    func getDistance(from: CLLocation) {
        if let location = self.location {
            let myLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            self.distance = Int(myLocation.distance(from: from))
        } else {
            self.distance = 000
        }
    }
    
}
