//
//  ContentView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //@ObservedObject var googleData = GoogleData()
    @EnvironmentObject var googleData: GoogleData
    
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    GoogleMapsView()
                        .frame(height: 280)
                    Button(action: {
                        
                    }) {
                        Text("Play Roulette!")
                    }
                    .foregroundColor(Color.blue)
                    .padding()
                    //.background(Color.white)
                        .background(Capsule().fill(Color.white))
                    //.clipShape(Capsule())
                        .overlay(
                            //RoundedRectangle(cornerRadius: 40)
                            Capsule()

                                .stroke(Color.blue, lineWidth: 1)
                        )
                        //.background(RoundedRectangle(cornerRadius: 40).fill(Color.blue))
                    .shadow(radius: 10)
                    .padding(.bottom, 10)
                    
                }
                
                List {
                    ForEach(self.googleData.results, id: \.name) { result in
                        Text(result.name)
                    }
                }
                
//                Button(action: loadData) {
//                    Text("load data")
//                }
            }
            .navigationBarTitle("Restaurant Roulette!", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: FilterView()) {
                    Image(systemName: "slider.horizontal.3")
                        .imageScale(.large)
                        .padding([.top, .bottom, .leading])
                        .contentShape(Rectangle())
                        
                }
            )
                
                
                .onAppear {
                    //self.googleData.loadData()
                    print(self.googleData.results)
            }
        }
    }
    
//    func loadData() {
//        googleData.loadData()
//        print("google data \(googleData.results)")
//        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=49.28,-123.12&radius=1500&type=restaurant&keyword=asian&key=AIzaSyBXH4Jxy02p-wwV-d_HC-EPeIBa-E7BjQk&opennow=true") else {
//            print("Invalid URL")
//            return
//        }
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//                    print("in decoder")
//                    // we have good data – go back to the main thread
//                    DispatchQueue.main.async {
//                        // update our UI
//                        self.results = decodedResponse.results
//                        print("results \(self.results)")
//                    }
//
//                    // everything is good, so we can exit
//                    return
//                }
//                print("data is good")
//                return
//            }
//
//            // if we're still here it means there was a problem
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//
//        }.resume()
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
