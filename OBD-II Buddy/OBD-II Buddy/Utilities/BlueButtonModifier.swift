//
//  BlueButtonModifier.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 12/24/23.
//

import SwiftUI

struct BlueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .frame(width: 300, height: 50)
            .font(.body)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
    }
}
