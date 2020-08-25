//
//  ContentView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    //@ObservedObject var googleData = GoogleData()
    @EnvironmentObject var googleData: GoogleData
    
    //@State private var results = [Result]()
    
    @State private var showingInfo = false
    @State private var errorAlert = false
    
    @State private var actionState: Int? = 0
    @State private var randomIndex: Int = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    GoogleMapsView()
                        .frame(height: 280)
                        .onAppear {
                            self.googleData.loadData(
                                near: self.googleData.centerCoordinate,
                                radius: self.googleData.radius,
                                openNow: self.googleData.openNow,
                                foodTypes: self.googleData.foodTypes
                            )
                        }
                    
                    
                    NavigationLink(destination: RestaurantView(randomIndex: self.$randomIndex), tag: 1, selection: $actionState) {
                        EmptyView()
                    }
                    
                    
                    Button(action: {
                        if self.googleData.results.isEmpty {
                            print("empty results")
                            self.errorAlert = true
                            
                        } else {
                            self.randomIndex = Int.random(in: 0..<self.googleData.results.count)
                            self.actionState = 1
                        }
                        
                        
                    }) {
                        Text("Play Roulette!")
                    }
                    .buttonStyle()
                    .alert(isPresented: self.$errorAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("No restaurants to pick from, try a new area."),
                            dismissButton: .default(Text("OK"))
                            )
                    }

                }
                
                NearbyPlacesView()
                

            }

            .alert(isPresented: self.$showingInfo) {
                Alert(title: Text("Info"),
                      message: Text("Drag the marker to desired location to search for restaurants nearby."),
                      dismissButton: .default(Text("Got it!")))
            }
            
            .navigationBarTitle("Restaurant Roulette!", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    self.showingInfo = true
                }) {
                    Image("info")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    
                },
                trailing:
                NavigationLink(destination: FilterView()) {
                    //Image(systemName: "slider.horizontal.3")
                    Image("slider")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
