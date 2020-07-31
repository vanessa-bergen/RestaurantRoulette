//
//  LocationManager.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    // variable to track the current user's location
    @Published var location: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // requesting the user for location access
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
  
    // update the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
