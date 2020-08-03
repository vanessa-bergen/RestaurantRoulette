//
//  GoogleData.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-03.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import CoreLocation

class GoogleData: ObservableObject {
    @Published var results = [Result]() {
        willSet {
            print("results set")
            objectWillChange.send()
        }
    }
    
    func loadData(
        near location: CLLocationCoordinate2D
    ) {
        print("triggered")
        print(location)
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=1500&type=restaurant&keyword=asian&key=\(API_KEY)&opennow=true") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    print("in decoder")
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.results
                        //print("results \(self.results)")
                    }

                    // everything is good, so we can exit
                    return
                }
                print("data is good")
                return
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}
