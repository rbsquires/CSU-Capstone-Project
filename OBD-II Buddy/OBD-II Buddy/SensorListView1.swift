//
//  SensorListView1.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/25/23.
//

import SwiftUI

struct SensorListView1: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    @Environment(\.presentationMode) var presentationMode // environment object that keeps track of what is shown
    //    var index: Int // Need to call this view with the index I am looking to change in LiveDataView()
    
    var body: some View {
        NavigationStack {
            List(bluetoothService.dataParser.liveSensors, id: \.self) { sensor in
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            Text(sensor.description)
                                .font(.subheadline)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(sensor.inUse ? .secondary.opacity(0.7) : .primary)
                        
                        if sensor.inUse && bluetoothService.dataParser.liveData[0].pidName == sensor.pidName {
                            
                            HStack {
                                Text(Image(systemName: "checkmark.circle"))
                                    .foregroundColor(.green)
                                    .padding(.trailing, 7)
                                
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        else if sensor.inUse {
                            
                            HStack {
                                Text("In Use")
                                    .font(.headline)
                                
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                                .opacity(0.7)
                                .foregroundColor(.secondary)
                        }
                        else {
                            HStack {
                                
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                    }
                    .lineLimit(1)
                    
                }
                .onTapGesture {
                    bluetoothService.dataParser.swapInUseForNewSensor(bluetoothService.dataParser.liveData[1].pidName)
                    
                    bluetoothService.dataParser.liveData[1].pidName = sensor.pidName
                    bluetoothService.dataParser.liveData[1].description = sensor.description
                    bluetoothService.dataParser.liveData[1].returnBytes = bluetoothService.dataParser.PIDBytes[sensor.pidName]!
                    bluetoothService.dataParser.liveData[1].data = 0
                    
                    bluetoothService.dataParser.populateLiveSensor()
                    
                    self.presentationMode.wrappedValue.dismiss() // dismissing current view once the text is tabbed
                    
                }
                .disabled(sensor.inUse)
                //                    .background(sensor.inUse ? .blur() : .red.opacity(0.15))
                
            }
            .navigationTitle("Available Sensors")
            
        }
    }
}

#Preview {
    SensorListView1()
        .environmentObject(BluetoothService())
}
