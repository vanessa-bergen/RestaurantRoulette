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
    //var id: String
    var name: String
    //var rating: Double
    //var price_level: Int
}
