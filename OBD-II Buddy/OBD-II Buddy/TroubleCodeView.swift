//
//  TroubleCodeView.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

struct TroubleCodeView: View {
    @EnvironmentObject var bluetoothService: BluetoothService
    
    var body: some View {
        // If there are DTCs, displays each code on a line in the list (Check engine light on dash)
        if !bluetoothService.dataParser.dtcData.isEmpty {
            VStack {
                Text("Search the DTCs below online for further info.")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Form {
                    List(bluetoothService.dataParser.dtcData, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                    }
                    .navigationTitle("Diagnostic Trouble Codes")
                }
                .onAppear(perform: callData)
                
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
                
                Spacer()
            }
        }
        // If no DTCs, displays that information to the user (No check engine light on dash)
        else {
            VStack {
                Form {
                    ContentUnavailableView {
                        Image(systemName: "hand.thumbsup.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 64))
                            .symbolEffect(.pulse)
                        
                        Text("No DTCs Found")

                    } description: {

                        Text("Please select another option from the Main Menu")
                    }
                }
                .navigationTitle("Diagnostic Trouble Codes")
                .background(Color.gray)
                .onAppear(perform: callData)
            }
        }
    }
    
    // Function used to request DTC information from the ECU in BluetoothService
    func callData() {
        bluetoothService.requestData(index: 1)
    }
}

#Preview {
    TroubleCodeView()
        .environmentObject(BluetoothService())
}
