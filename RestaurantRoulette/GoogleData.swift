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
    
    var temp = [Result]()
    
    @Published var radius: Double = 5
    @Published var price = 2

    @Published var openNow = true
    var foodTypes: [String] = [] {
        didSet {
            print("foodTypes \(foodTypes)")
        }
    }
    
    @Published var centerCoordinate = CLLocationCoordinate2D() {
        didSet {
            print("center coordinate set \(centerCoordinate)")
            loadData(
                near: centerCoordinate,
                radius: self.radius,
                openNow: self.openNow,
                foodTypes: self.foodTypes
            )
        }
    }
    
    let group = DispatchGroup()
    
    func loadData(
        near location: CLLocationCoordinate2D,
        radius: Double,
        openNow: Bool,
        foodTypes: [String]
        //completionHandler: @escaping ([Result]) -> Void
    ) {
        print("called loadData")
        temp.removeAll()
        
        if foodTypes.isEmpty {
            print("food is empty")
            self.foodTypes = [""]
        }
        
        let urls = foodTypes.map { "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius * 1000)&type=restaurant&keyword=\($0)&key=\(API_KEY)"
            
        }
        print("urls \(urls)")
        
        
        for url in urls {
            group.enter()
            
            print("first url \(url), in dispatch")
            
            guard let url = URL(string: url) else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    fatalError("Error: \(error.localizedDescription)")
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    fatalError("Error: invalid HTTP response code")
                }
                guard let data = data else {
                    fatalError("Error: missing response data")
                }
                    
                do {
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    print("in decoder 1")
                        // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.temp.append(contentsOf: decodedResponse.results)
                        //self.googleData.results.append(contentsOf: decodedResponse.results)
                        //self.googleData.results = decodedResponse.results
                        //print("results 1\(self.temp)")
                        //self.results = self.temp.map { $0 }
                        self.group.leave()
                    }
                    return
                    
                } catch {
                    print("Error 1: \(error.localizedDescription)")
                }
            
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                
            }.resume()
            
        }

        group.notify(queue: DispatchQueue.main) {
            print("done dispath")
            //print("temp \(self.temp)")
            self.results = self.temp.map { $0 }
            //print("new results \(self.results)")
            
            //completionHandler(self.temp)
            //completionHandler(self.temp)
        }

    }
}
