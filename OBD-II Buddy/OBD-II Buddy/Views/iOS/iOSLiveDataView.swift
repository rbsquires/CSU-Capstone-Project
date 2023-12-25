//
//  iOSLiveDataView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

// Custom View modifier to track rotation andcall our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct iOSLiveDataView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss // environment object that keeps track of what is shown
    @State private var showingSensors0 = false
    @State private var showingSensors1 = false
    @State private var showingSensors2 = false
    @State private var showingSensors3 = false
    @State private var orientation = UIDeviceOrientation.unknown
    let timer = Timer.publish(every: 1.5, tolerance: 0.5, on: .main, in: .common).autoconnect()
    private var firstLoad = true
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                // Shows Live Data for Sensor 0 (Top-Left)
                HStack {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors0.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[0].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[0].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors0, content: SensorListView0.init)
                        .modifier(SensorDataModifier())
                        .onReceive(timer) { time in
                            if bluetoothService.stopData && !showingSensors0 && !showingSensors1 && !showingSensors2 && !showingSensors3 {
                                
                                bluetoothService.requestData(index: 0)
                                
                            }
                            else if showingSensors0 || showingSensors1 || showingSensors2 || showingSensors3 {
                                print("requestData() is paused")
                            }
                            
                            else {
                                timer.upstream.connect().cancel()
                            }
                        }
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[0].pidName] ?? "Nil")")
                            .modifier(SensorDescriptionModifier())
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                // Extra horizontal spacer if landscape view detected
                Group {
                    if orientation.isLandscape {
                        HStack(alignment: .center) {
                        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                // Shows Live Data for Sensor 1 (Top-Right)
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors1.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[1].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[1].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors1, content: SensorListView1.init)
                        .modifier(SensorDataModifier())
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[1].pidName] ?? "Nil")")
                            .modifier(SensorDescriptionModifier())
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            
            
            Spacer()
            Spacer()
            
            VStack {
                Image(colorScheme == .light ? "App Logo (Light)" : "App Logo (Dark)")
                    .resizable()
                    .frame(width: 120, height: 120)
                
                Text("Double Tap Icon to Home")
                    .fontWeight(.bold)
                    .font(.caption2)
                    .opacity(0.8)
            }
            .onTapGesture(count: 2) {
                bluetoothService.stopData.toggle()
                timer.upstream.connect().cancel()
                dismiss()
            }
            
            Spacer()
            Spacer()
            
            HStack {
                // Shows Live Data for Sensor 2 (Bottom-Left)
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors2.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[2].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[2].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors2, content: SensorListView2.init)
                        .modifier(SensorDataModifier())
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[2].pidName] ?? "Nil")")
                            .modifier(SensorDescriptionModifier())
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                // Extra horizontal spacer if landscape view detected
                Group {
                    if orientation.isLandscape {
                        HStack(alignment: .center) {
                        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                // Shows Live Data for Sensor 3 (Bottom-Right)
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors3.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[3].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[3].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors3, content: SensorListView3.init)
                        .modifier(SensorDataModifier())
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[3].pidName] ?? "Nil")")
                            .modifier(SensorDescriptionModifier())
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
            }
            
            Spacer()
            
        }
        .toolbar(content: BluetoothConnectionViewToolbar.init)
        .navigationBarBackButtonHidden(true) // hide the back button
        .onAppear(perform: { // Setting screen to not dim/lock during Live Data
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .onDisappear(perform: { // Setting screen to dim/lock on idle
            UIApplication.shared.isIdleTimerDisabled = false
        })
    }
}

#Preview {
    iOSLiveDataView()
        .environmentObject(BluetoothService())
}
