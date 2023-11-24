//
//  BluetoothConnectionViewToolbar.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

struct BluetoothConnectionViewToolbar: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    
    var body: some View {
        HStack {
            
            if bluetoothService.peripheralStatus == .connected {
                Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                    .foregroundColor(.green)
            }
            else if bluetoothService.peripheralStatus == .scanning {
                Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                    .foregroundColor(.yellow)
            }
            else {
                Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                    .foregroundColor(.red)
            }
            
            
            if bluetoothService.stopData {
                Image(systemName: "car.front.waves.up.fill")
                    .foregroundColor(.green)
                    .symbolEffect(.variableColor)
            }
            else {
                Image(systemName: "car.front.waves.up.fill")
                    .foregroundColor(.red)
            }
        }
//        .fontWeight(.bold)
    }
}

#Preview {
    BluetoothConnectionViewToolbar()
        .environmentObject(BluetoothService())
}
