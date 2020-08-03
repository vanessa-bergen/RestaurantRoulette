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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
