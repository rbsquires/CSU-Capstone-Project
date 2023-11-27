//
//  AvailableDeviceView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

struct AvailableDeviceView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @Environment(\.dismiss) var dismiss // environment object that keeps track of what is shown
    
    var body: some View {
        // Displays available Bluetooth peripherals
        VStack {
            Form {
                // List of Bluetooth peripherals in your area, remove if to see all devices
                List(bluetoothService.peripherals, id: \.self) { peripheral in
                    if peripheral.identifier.description == "715F4D00-B472-1F8B-7ED0-4F10B542017E" || peripheral.identifier.description == "4BCC77F9-32AC-0C74-BB65-365ECF59F447" {
                        VStack(alignment: .leading) {
                            Text(peripheral.name ?? "Unamed Device")
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text(peripheral.identifier.description)
                                .font(.footnote)
                                .lineLimit(1)
                            
                        }
                        .onTapGesture {
                            bluetoothService.obdSensorPeripheral = peripheral
                            bluetoothService.selectedAdapterName = peripheral.name!
                            bluetoothService.selectedSensor = peripheral.identifier
                            
                            bluetoothService.connectToDevice(peripheral)
                            
                            print("Connecting to \(String(describing: peripheral.name)) from: (ContentView)")
                            
                            bluetoothService.populateData.toggle()
                            
                            dismiss() // dismissing current view once the text is tabbed
                            
                        }
                        .environmentObject(bluetoothService)
                    }
                }
                .navigationTitle("Peripherals")
            }
        }
    }
}

#Preview {
    AvailableDeviceView()
        .environmentObject(BluetoothService())
}
