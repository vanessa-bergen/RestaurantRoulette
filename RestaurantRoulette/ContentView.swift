//
//  ContentView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import CoreLocation

enum ActiveAlert {
    case info, error
}

struct ContentView: View {
    
    @EnvironmentObject var googleData: GoogleData
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .info
    
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
                            self.activeAlert = .error
                            self.showAlert = true
                            
                        } else {
                            self.randomIndex = Int.random(in: 0..<self.googleData.results.count)
                            self.actionState = 1
                        }
                        
                        
                    }) {
                        Text("Play Roulette!")
                    }
                    .buttonStyle()
                }

                NearbyPlacesView()
                
            }
            .alert(isPresented: self.$showAlert) {
                switch self.activeAlert {
                case .info:
                    return Alert(
                        title: Text("Info"),
                        message: Text("Drag the marker to desired location to search for restaurants nearby."),
                        dismissButton: .default(Text("Got it!"))
                    )
                
                case .error:
                    return Alert(
                        title: Text("Error"),
                        message: Text("No restaurants to pick from, try a new area."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
            }
            
            .navigationBarTitle("Restaurant Roulette!", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    self.activeAlert = .info
                    self.showAlert = true
                }) {
                    Image("info")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    
                },
                trailing:
                NavigationLink(destination: FilterView()) {
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
