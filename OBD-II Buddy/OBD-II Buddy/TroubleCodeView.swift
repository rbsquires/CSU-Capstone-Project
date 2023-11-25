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
