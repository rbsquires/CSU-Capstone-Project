//
//  LiveDataSensorModifier.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 12/24/23.
//

import SwiftUI

struct SensorDescriptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.subheadline)
            .lineLimit(1)
    }
}
