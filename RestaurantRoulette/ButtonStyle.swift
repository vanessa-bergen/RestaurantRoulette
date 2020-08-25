//
//  ButtonStyle.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-19.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.darkBlue)
            .padding()
            .background(Capsule().fill(Color.white))
            .overlay(
                Capsule()
                    .stroke(Color.darkBlue, lineWidth: 1)
            )
            .shadow(radius: 10)
            .padding(.bottom, 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
}
