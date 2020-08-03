//
//  FilterView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @State private var distance: Double = 5
    @State private var openNow = true
    @State private var price = 2
    @State private var allFoods = true
    @State private var asian = false
    @State private var bbq = false
    @State private var burgers = false
    
    var body: some View {
        Form {
            
            Section(header: Text("Distance From Pinned Location")) {
                VStack {
                    HStack {
                        Text("Distance")
                        Spacer()
                        Text("\(self.distance, specifier: "%.0f") KM")
                    }
                    HStack {
                        Text("1")
                        Slider(value: self.$distance, in: 1...20, step: 1.0)
                        Text("20")
                    }
                }
            }
            
            Section(header: Text("Price Range")) {
                PriceView(price: self.$price, maxPrice: 5)
            }
            
            Section(header: Text("Only Search Restaurancts Open Now")) {
                Toggle(isOn: self.$openNow) {
                    Text("Open Now?")
                }
            }
            
            Section(header: Text("Food Types")) {
                Toggle(isOn: self.$allFoods.animation()) {
                    Text("All")
                }
                if !self.allFoods {
                    Toggle(isOn: self.$asian) {
                        Text("Asian")
                    }
                    Toggle(isOn: self.$bbq) {
                        Text("Barbeque")
                    }
                    Toggle(isOn: self.$burgers) {
                        Text("Burgers")
                    }
                }
            }
        }
        .navigationBarTitle(Text("Filter Criteria"))
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
