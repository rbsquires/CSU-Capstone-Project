//
//  TroubleCodeView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 11/5/23.
//

import SwiftUI

struct TroubleCodeView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    
    var body: some View {
        if !bluetoothService.dataParser.dtcData.isEmpty {
            VStack {
                Text("Search the DTCs below online for further info.")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Form {
                    List(bluetoothService.dataParser.dtcData, id: \.self) { item in
                        //                VStack(alignment: .leading) {
                        Text(item)
                            .font(.headline)
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                        //                    Text(peripheral.identifier.description)
                        //                        .font(.footnote)
                        //                        .lineLimit(1)
                        
                        //                }
                        //                .onTapGesture {
                        //                    bluetoothService.obdSensorPeripheral = peripheral
                        //                    bluetoothService.selectedAdapterName = peripheral.name!
                        //                    bluetoothService.selectedSensor = peripheral.identifier
                        //
                        //                    bluetoothService.connectToDevice(peripheral)
                        //
                        //                    print("Connecting to \(String(describing: peripheral.name)) from: (ContentView)")
                        //
                        ////                    self.presentationMode.wrappedValue.dismiss() // dismissing current view once the text is tabbed
                        //
                        //                }
                        //                        .environmentObject(bluetoothService)
                    }
                    .navigationTitle("Diagnostic Trouble Codes")
                }
                .onAppear(perform: callData)
                //                .background(Color.gray)
                
                Spacer()
                
                Button("Clear DTCs") {
                    bluetoothService.requestData(index: 10)
                    bluetoothService.dataParser.dtcData.removeAll()
                }
                .bold()
                .frame(width: 280, height: 50)
                .font(.body)
                .foregroundColor(.primary)
                .background(Color.blue)
                .cornerRadius(10)
                //                .font(.largeTitle)
                //                .foregroundColor(.green)
                //                .frame(alignment: .center)
                
                Spacer()
            }
        }
        else {
            VStack {
                Form {
                    Text("No DTCs Found")
                        .bold()
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .navigationTitle("Diagnostic Trouble Codes")
                .background(Color.gray)
                .onAppear(perform: callData)
            }
        }
    }
    
    func callData() {
        bluetoothService.requestData(index: 1)
    }
}

#Preview {
    TroubleCodeView()
        .environmentObject(BluetoothService())
}
