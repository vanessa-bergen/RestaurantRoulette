//
//  RestaurantView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import MapKit

struct RestaurantView: View {
    @EnvironmentObject var googleData: GoogleData
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var randomIndex: Int
    @State private var errorAlert = false
    
    var chosenRestaurant: Result {
        self.googleData.results[randomIndex]
    }
    
    @State private var doneScrolling = false
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                InfiniteScrollView(
                    indexToScroll: self.$randomIndex,
                    dataSource: self.googleData.results,
                    doneScrolling: self.$doneScrolling
                )
                
                if self.doneScrolling {
                    Button(action: {
                        guard let coordinate = self.chosenRestaurant.coordinate else {
                            self.errorAlert = true
                            return
                        }
                        self.openMapsAppWithDirections(to: coordinate, destinationName: self.chosenRestaurant.name ?? "")
                    }) {
                        HStack {
                            Text("Get Directions")
                            Image(systemName: "map.fill")
                        }
                    }
                    .buttonStyle()
                    .padding(.bottom, 20)
                }
            }
            .alert(isPresented: self.$errorAlert) {
                Alert(title: Text("Error Getting Directions"), message: Text("Not able to display directions"), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}

