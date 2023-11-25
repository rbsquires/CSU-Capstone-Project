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
        else if bluetoothService.peripheralStatus != .connected && !bluetoothService.populateData {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: AvailableDeviceView(), label: {
                        Text("Show Available Bluetooth Devices")
                            .bold()
                            .frame(width: 300, height: 50)
                            .font(.body)
                            .foregroundColor(.primary)
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
        else {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        NavigationLink(destination: iPadOSLiveDataView()) {
                            Text("Live Data View")
                                .bold()
                                .frame(width: 280, height: 50)
                                .font(.body)
                                .foregroundColor(.primary)
                                .background(Color.blue)
                                .cornerRadius(10)
                            
                        }.simultaneousGesture(TapGesture().onEnded{
                            bluetoothService.stopData.toggle()

                        })
                        
                    }
                    else {
                        NavigationLink(destination: iOSLiveDataView()) {
                            Text("Live Data View")
                                .bold()
                                .frame(width: 280, height: 50)
                                .font(.body)
                                .foregroundColor(.primary)
                                .background(Color.blue)
                                .cornerRadius(10)
                            
                        }.simultaneousGesture(TapGesture().onEnded{
                            bluetoothService.stopData.toggle()

                        })
                        
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: TroubleCodeView()) {
                        Text("Trouble Code View")
                            .bold()
                            .frame(width: 280, height: 50)
                            .font(.body)
                            .foregroundColor(.primary)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: VehicleInfoView()) {
                        Text("Vehicle Info View")
                            .bold()
                            .frame(width: 280, height: 50)
                            .font(.body)
                            .foregroundColor(.primary)
                            .background(Color.blue)
                            .cornerRadius(10)
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
