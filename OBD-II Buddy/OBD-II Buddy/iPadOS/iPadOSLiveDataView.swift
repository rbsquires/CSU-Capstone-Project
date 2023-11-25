//
//  iPadOSLiveDataView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 11/22/23.
//

import SwiftUI

struct iPadOSLiveDataView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss // environment object that keeps track of what is shown
    @State private var showingSensors0 = false
    @State private var showingSensors1 = false
    @State private var showingSensors2 = false
    @State private var showingSensors3 = false
    let timer = Timer.publish(every: 1.5, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        if !bluetoothService.closedLiveData {
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
                    
                    Spacer()
                    
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
                        .frame(width: 240, height: 240)

                    Text("Double Tap Icon to Stop Live Data")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .opacity(0.8)
                }
                .onTapGesture(count: 2) {
                    bluetoothService.stopData.toggle()
                    bluetoothService.closedLiveData.toggle()
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
                    
                    Spacer()
                    
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
            .navigationBarBackButtonHidden(true)
        }
        else {
            ContentUnavailableView {
                Image(colorScheme == .light ? "App Logo (Light)" : "App Logo (Dark)")
                    .resizable()
                    .frame(width: 480, height: 480)
                
                Text("Please select another option from the menu")

            } description: {

                Text("Live Data View, Trouble Code View or Vehicle Info View")
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    iPadOSLiveDataView()
        .environmentObject(BluetoothService())
}
