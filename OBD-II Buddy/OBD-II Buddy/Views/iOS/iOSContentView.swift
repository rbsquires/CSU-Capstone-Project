//
//  iOSContentView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

struct iOSContentView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @State private var isRotating = 0.0
    
    var body: some View {
        // Shows loading screen during Bluetooth init and vehicle info request
        if bluetoothService.populateData {
            NavigationStack {
                ContentUnavailableView {
                    Image(systemName: "gear")
                        .font(.system(size: 84))
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.1).repeatForever(autoreverses: false)) {
                                    isRotating = 360.0
                                }
                        }
                    
                    Text("Initializing Bluetooth Connection")
                    
                } description: {
                    
                    Text("Connecting to \(bluetoothService.selectedAdapterName)")
                }
                .padding(.bottom, 90)
                .navigationTitle("OBD-II Buddy")
            }
        }
        // Shows available Bluetooth peripherals button
        else if bluetoothService.peripheralStatus != .connected && !bluetoothService.populateData {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: AvailableDeviceView(), label: {
                        Text("Show Available Bluetooth Devices")
                            .modifier(BlueButtonModifier())
                    })
                    
                    Spacer()
                    
                }
                .navigationTitle("OBD-II Buddy")
                .toolbar(content: BluetoothConnectionViewToolbar.init)
            }
            .environmentObject(bluetoothService)
        }
        // Main menu when connected to OBD-II Bluetooth device
        else {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: iOSLiveDataView()) {
                        Text("Live Data View")
                            .modifier(BlueButtonModifier())
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        bluetoothService.stopData.toggle()

                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: TroubleCodeView()) {
                        Text("Trouble Code View")
                            .modifier(BlueButtonModifier())
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: VehicleInfoView()) {
                        Text("Vehicle Info View")
                            .modifier(BlueButtonModifier())
                    }
                    
                    Spacer()
                    
                }
                .navigationTitle("OBD-II Buddy")
                .toolbar(content: BluetoothConnectionViewToolbar.init)
                
                
                
            }
            .environmentObject(bluetoothService)
            
            Spacer()
            
        }
    }
}

#Preview {
    iOSContentView()
        .environmentObject(BluetoothService())
}
