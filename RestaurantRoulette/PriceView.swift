//
//  PriceView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-07-31.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct PriceView: View {
    
    @Binding var price: Int
    
    var maxPrice: Int
    var onImage = "dollarFilled"
    var offImage = "dollarEmpty"
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<maxPrice+1) { number in
                self.image(for: number)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .onTapGesture {
                        self.price = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number <= self.price {
            return Image(onImage)
        } else {
            return Image(offImage)
        }
    }
}
