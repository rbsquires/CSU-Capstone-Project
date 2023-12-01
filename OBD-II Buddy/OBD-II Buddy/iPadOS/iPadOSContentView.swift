//
//  iPadOSContentViewIPADOS.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 11/23/23.
//

import SwiftUI

struct iPadOSContentView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @State private var isRotating = 0.0
    
    var body: some View {
        // Shows loading screen during Bluetooth init and vehicle info request
        if bluetoothService.populateData {
            NavigationView {
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
        // Shows available Bluetooth peripherals
        else if bluetoothService.peripheralStatus != .connected && !bluetoothService.populateData {
            NavigationView {
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: AvailableDeviceView(), label: {
                        Text("Show Available Bluetooth Devices")
                            .bold()
                            .frame(width: 300, height: 50)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
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
            NavigationView {
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: iPadOSLiveDataView()) {
                        Text("Live Data View")
                            .bold()
                            .frame(width: 280, height: 50)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        if !bluetoothService.stopData {
                            bluetoothService.stopData.toggle()
                            if bluetoothService.closedLiveData{
                                bluetoothService.closedLiveData.toggle()
                            }
                        }
                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: TroubleCodeView()) {
                        Text("Trouble Code View")
                            .bold()
                            .frame(width: 280, height: 50)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        if bluetoothService.closedLiveData {
                            bluetoothService.closedLiveData.toggle()
                            print("closedLiveData = \(bluetoothService.closedLiveData)")
                        }
                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: VehicleInfoView()) {
                        Text("Vehicle Info View")
                            .bold()
                            .frame(width: 280, height: 50)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }.simultaneousGesture(TapGesture().onEnded{
                        if bluetoothService.closedLiveData {
                            bluetoothService.closedLiveData.toggle()
                            print("closedLiveData = \(bluetoothService.closedLiveData)")
                        }
                    })
                    
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
    iPadOSContentView()
}
