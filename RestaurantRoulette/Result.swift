//
//  Result.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-03.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import MapKit


struct Response: Codable {
    var results: [Result]
}

struct Result: Codable, Hashable {
    
    var place_id: String
    var name: String?
    var rating: Double?
    var vicinity: String?
    var price_level: Int?
    var opening_hours: OpenNow?
    var geometry: Location?
    
    var ratingFormatted: String {
        if let rating = self.rating {
            return String(format: "%.1f", rating)
        } else {
            return "No Rating"
        }
    }
    
    var open: Bool {
        guard let opening_hours = self.opening_hours else {
            // if there are no opening_hours, return true so that it will be included in the results
            return true
        }
        return opening_hours.open_now
    }
    
    var price: Int {
        guard let price_level = self.price_level else {
            // if there is no price level, set it to the lowest price so that it will be included in the results
            return 1
        }
        return price_level
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let geometry = self.geometry, let location = geometry.location else {
            print("Error: No Coordinates")
            return nil
        }
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        
            
    }
    
    // conforming to hashable
    static func == (lhs: Result, rhs: Result) -> Bool {
        lhs.place_id == rhs.place_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(place_id)
    }
    
}

struct OpenNow: Codable {
    var open_now: Bool
}

struct Location: Codable {
    var location: Coordinates?
}

struct Coordinates: Codable {
    var lat: CLLocationDegrees
    var lng: CLLocationDegrees
}
