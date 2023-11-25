//
//  VehicleInfoView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

struct VehicleInfoView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    
    var body: some View {
        
        Form {
            VStack {
                HStack {
                    Text("VIN:")
                    
                    Spacer()
                    
                    Text(bluetoothService.dataParser.vinNumber)
                }
                
                
                Spacer()
                
                HStack {
                    Text("Calibration ID:")
                    
                    Spacer()
                    
                    Text(bluetoothService.dataParser.calibrationID)
                }
                
                Spacer()
                
                HStack {
                    Text("OBD-II Protocol:")
                    
                    Spacer()
                    
                    Text(bluetoothService.dataParser.obdProtocol)
                }
                .lineLimit(1)
                
                Spacer()
                
                HStack {
                    Text("ECU Name:")
                    
                    Spacer()
                    
                    Text(bluetoothService.dataParser.ecuName)
                }
                .lineLimit(1)
                
                Spacer()
                
                HStack {
                    Text("Fuel Type:")
                    
                    Spacer()
                    
                    Text(bluetoothService.dataParser.fuelType)
                }
                .lineLimit(1)
            }
            .padding()
        }
        .navigationTitle("Vehicle Information")
        
    }
}

#Preview {
    VehicleInfoView()
        .environmentObject(BluetoothService())
}
