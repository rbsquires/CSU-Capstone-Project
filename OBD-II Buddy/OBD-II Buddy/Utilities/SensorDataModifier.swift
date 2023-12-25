//
//  SensorDataModifier.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 12/24/23.
//

import SwiftUI

struct SensorDataModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .font(.title)
            .bold()
    }
}
