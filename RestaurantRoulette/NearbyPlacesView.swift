//
//  NearbyPlacesView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-03.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct NearbyPlacesView: View {
    
    @EnvironmentObject var googleData: GoogleData
    let dollarSign = "$"
    
    var body: some View {
        //NavigationView {
        VStack {
            Text("Nearby Restaurants")
                .fontWeight(.semibold)
            Divider()
            List {
                ForEach(self.googleData.results, id: \.place_id) { result in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(result.name ?? "Name Not Found")
                                .font(.headline)
                            Spacer()
                            Text(result.ratingFormatted)
                                .font(.headline)
                            +
                            Text(" ★")
                                .foregroundColor(.yellow)
                                .font(.headline)
                        }
                        .font(.headline)
                        .lineLimit(nil)
                        
                        HStack(spacing: 0) {
                            if result.price_level != nil {
                                Text(String(repeating: "$", count: result.price_level!))
                                + Text("・")
                            }
                            
                            Text(result.vicinity ?? "Address Not Found")
                                
                        }
                        .font(.subheadline)
                        .lineLimit(nil)
                    }
                }
            }
            //.navigationBarTitle(Text("Nearby Restaurants"), displayMode: .inline)
        }
    }
}

struct NearbyPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyPlacesView()
    }
}
