//
//  iPadBlankView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 11/22/23.
//

import SwiftUI

struct iPadOSBlankView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
   
        ContentUnavailableView {
            Image(colorScheme == .light ? "App Logo (Light)" : "App Logo (Dark)")
                .resizable()
                .frame(width: 480, height: 480)
            
            Text("Please select another option from the menu")

        } description: {

            Text("Trouble Code View or Vehicle Info View")
        }
        .navigationBarHidden(true)

    }
}

#Preview {
    iPadOSBlankView()
        .environmentObject(BluetoothService())
}
