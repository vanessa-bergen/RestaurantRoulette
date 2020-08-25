//
//  FilterView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var googleData: GoogleData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var allFoods = true
    @State private var asian = false
    @State private var bbq = false
    @State private var burger = false
    @State private var dessert = false
    @State private var indian = false
    @State private var italian = false
    @State private var mexican = false
    @State private var pizza = false
    @State private var pub = false
    @State private var seafood = false
    @State private var vegetarian = false
    @State private var other = false
    @State private var otherType = ""
    
    
    var body: some View {
        Form {
            
            Section(header: Text("Distance From Pinned Location")) {
                VStack {
                    HStack {
                        Text("Distance")
                        Spacer()
                        Text("\(self.googleData.radius, specifier: "%.0f") KM")
                    }
                    HStack {
                        Text("1")
                        Slider(value: self.$googleData.radius, in: 1...20, step: 1.0)
                        Text("20")
                    }
                }
            }
            
            Section(header: Text("Price Range")) {
                PriceView(price: self.$googleData.price, maxPrice: 4)
            }
            
            Section(header: Text("Only Search Restaurants Open Now")) {
                Toggle(isOn: self.$googleData.openNow) {
                    Text("Open Now?")
                }
            }
            
            Section(header: Text("Food Types")) {
                Toggle(isOn: self.$allFoods.didSet { (state) in
                    self.googleData.foodTypes.removeAll()
                }.animation()) {
                    Text("All")
                }
                
                if !self.allFoods {
                    Group {
                        Toggle(isOn: self.$asian.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "asian")
                        }) {
                            Text("Asian")
                        }
                        
                        Toggle(isOn: self.$bbq.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "barbeque")
                        }) {
                            Text("Barbeque")
                        }
                        
                        Toggle(isOn: self.$burger.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "burger")
                        }) {
                            Text("Burgers")
                        }
                        
                        Toggle(isOn: self.$dessert.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "dessert")
                        }) {
                            Text("Dessert")
                        }
                        
                        Toggle(isOn: self.$indian.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "indian")
                        }) {
                            Text("Indian")
                        }
                    }
                    
                    Group {
                    
                        Toggle(isOn: self.$italian.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "italian")
                        }) {
                            Text("Italian")
                        }
                        
                        Toggle(isOn: self.$mexican.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "mexican")
                        }) {
                            Text("Mexican")
                        }
                        
                        Toggle(isOn: self.$pizza.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "pizza")
                        }) {
                            Text("Pizza")
                        }
                        
                        Toggle(isOn: self.$pub.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "pub")
                        }) {
                            Text("Pub")
                        }
                        
                        Toggle(isOn: self.$seafood.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "seafood")
                        }) {
                            Text("Seafood")
                        }
                        
                        Toggle(isOn: self.$vegetarian.didSet { (state) in
                            self.updateFoodTypes(state: state, name: "vegetarian")
                        }) {
                            Text("Vegetarian")
                        }
                        
                        Toggle(isOn: self.$other.animation()) {
                            Text("Other")
                        }
                        
                        if self.other {
                            TextField("Other Food Type", text: self.$otherType)
                        }
                    }
                }
            }
        }
        .onAppear(perform: initFoodTypes)
        .navigationBarTitle(Text("Filter Criteria"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.updateFoodTypes(state: self.other, name: self.otherType)
                if self.googleData.foodTypes.isEmpty {
                    print("setting quotes")
                    self.googleData.foodTypes = [""]
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Text("Go Back")
                }
        })
    }
    
    func updateFoodTypes(state: Bool, name: String) -> Void {
        if state {
            self.googleData.foodTypes.append(name)
        } else {
            if let index = self.googleData.foodTypes.firstIndex(of: name) {
                self.googleData.foodTypes.remove(at: index)
            }
        }
    }
    
    func initFoodTypes() {
        if self.googleData.foodTypes.isEmpty || (self.googleData.foodTypes.count == 1 && self.googleData.foodTypes[0] == "") {
            self.allFoods = true
        } else {
            self.allFoods = false
            for foodType in self.googleData.foodTypes {
                switch foodType {
                case "asian":
                    self.asian = true
                case "barbeque":
                    self.bbq = true
                case "burger":
                    self.burger = true
                case "dessert":
                    self.dessert = true
                case "indian":
                    self.indian = true
                case "italian":
                    self.indian = true
                case "mexican":
                    self.mexican = true
                case "pizza":
                    self.pizza = true
                case "pub":
                    self.pub = true
                case "vegetarian":
                    self.vegetarian = true
                default:
                    self.other = true
                    self.otherType = foodType
                }
            }
        }
    }
}


extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    
}
