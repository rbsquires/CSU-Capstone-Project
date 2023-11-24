//
//  LiveDataView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI
// Our custom view modifier to track rotation and
// call our action
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
    let timer = Timer.publish(every: 1.5, tolerance: 0.5, on: .main, in: .common).autoconnect()
    private var firstLoad = true
    @State private var showingSensors0 = false
    @State private var showingSensors1 = false
    @State private var showingSensors2 = false
    @State private var showingSensors3 = false
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                HStack {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors0.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[0].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[0].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors0, content: SensorListView0.init)
                        .buttonStyle(.plain)
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
                        .font(.title)
                        .bold()
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[0].pidName] ?? "Nil")")
                            .bold()
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                Group {
                    if orientation.isLandscape {
                        HStack(alignment: .center) {
                        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors1.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[1].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[1].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors1, content: SensorListView1.init)
                        .buttonStyle(.plain)
                        .font(.title)
                        .bold()
                        
                        //                        Text("\(bluetoothService.dataParser.vehicleInfo2.description)")
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[1].pidName] ?? "Nil")")
                            .bold()
                            .font(.subheadline)
                            .lineLimit(1)
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
                
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors2.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[2].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[2].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors2, content: SensorListView2.init)
                        .buttonStyle(.plain)
                        .font(.title)
                        .bold()
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[2].pidName] ?? "Nil")")
                            .bold()
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                Group {
                    if orientation.isLandscape {
                        HStack(alignment: .center) {
                        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Button {
                            showingSensors3.toggle()
                        } label: {
                            Text("\(bluetoothService.dataParser.liveData[3].data) \(bluetoothService.dataParser.PIDTypes[bluetoothService.dataParser.liveData[3].pidName] ?? "Nil")")
                        }
                        .sheet(isPresented: $showingSensors3, content: SensorListView3.init)
                        .buttonStyle(.plain)
                        .font(.title)
                        .bold()
                        
                        Text("\(bluetoothService.dataParser.PIDDescription[bluetoothService.dataParser.liveData[3].pidName] ?? "Nil")")
                            .bold()
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
            }
            
            Spacer()
            
        }
        .toolbar(content: BluetoothConnectionViewToolbar.init)
        .navigationBarBackButtonHidden(true) // hide the back button
        //                .navigationBarHidden(true)
        
    }
}

#Preview {
    iOSLiveDataView()
        .environmentObject(BluetoothService())
}
