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
        // Displays the toolbar, with Bluetooth connection status and vehicle communication symbols
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
    }
}

#Preview {
    BluetoothConnectionViewToolbar()
        .environmentObject(BluetoothService())
}
