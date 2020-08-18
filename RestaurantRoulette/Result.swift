//
//  Result.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-03.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI


struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var place_id: String
    var name: String?
    var rating: Double?
    var vicinity: String?
    var price_level: Int?
    
    var ratingFormatted: String {
        if let rating = self.rating {
            return String(format: "%.1f", rating)
        } else {
            return "No Rating"
        }
    }
    
}
