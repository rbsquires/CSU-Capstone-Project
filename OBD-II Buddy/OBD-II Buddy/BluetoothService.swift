//
//  BluetoothService.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import Foundation
import CoreBluetooth

enum ConnectionStatus: String {
    case connected
    case disconnected
    case scanning
    case connecting
    case error
}

class BluetoothService: NSObject, ObservableObject {
    @Published var dataParser = DataParser()
    
    @Published var peripheralStatus: ConnectionStatus = .disconnected
    @Published var peripheralNames: [String] = []
    @Published var openedApp: Bool = true
    @Published var stopData: Bool = false
    @Published var sendData: Bool = false
    @Published var poweredOff: Bool = false
    @Published var populateData: Bool = false
    @Published var closedLiveData: Bool = false
    @Published var showiPadBlank: Bool = false
    @Published var commands: [Data] = ["01050C4210\r\n".data(using: .utf8)!, "03\r\n".data(using: .utf8)!, "ATDP\r\n".data(using: .utf8)!, "0902\r\n".data(using: .utf8)!, "0904\r\n".data(using: .utf8)!, "090A\r\n".data(using: .utf8)!, "0151\r\n".data(using: .utf8)!, "0100\r\n".data(using: .utf8)!, "0120\r\n".data(using: .utf8)!, "0140\r\n".data(using: .utf8)!, "04\r\n".data(using: .utf8)!]
    private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    var obdSensorPeripheral: CBPeripheral?
    var obdSensorCharacteristic: CBCharacteristic?
    var selectedSensor: UUID?
    var selectedAdapterName: String = ""
    var finalData: String = ""
    var commandStr: String = ""
    
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        dataParser.populateLiveData()
    }
    
    func scanForPeripherals() {
        peripheralStatus = .scanning
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func write(value: Data, characteristic: CBCharacteristic) {
        //        print("sendData = \(sendData) inside write()")
        if ((obdSensorPeripheral?.canSendWriteWithoutResponse) != nil && sendData) {
            //            print("*************** Made it into write ***************")
            self.obdSensorPeripheral?.writeValue(value, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    func read(characteristic: CBCharacteristic) {
        if ((obdSensorPeripheral?.canSendWriteWithoutResponse) != nil) {
            //            print("*************** Made it into read ***************")
            self.obdSensorPeripheral?.readValue(for: characteristic)
            //            sendData = false
        }
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("CB Powered On")
            scanForPeripherals()
        }
        else if central.state == .poweredOff {
            print("CB Powered Off")
            poweredOff = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if selectedAdapterName != "" {
            if peripheral.name == selectedAdapterName {
                //                print("Discovered \(peripheral.name ?? selectedAdapterName)")
                //                print(" \(selectedAdapterName) identifier: \(peripheral.identifier)")
                obdSensorPeripheral = peripheral
                centralManager?.connect(obdSensorPeripheral!)
                peripheralStatus = .connecting
            }
        }
        else {
            if !peripherals.contains(peripheral) {
                self.peripherals.append(peripheral)
                self.peripheralNames.append(peripheral.name ?? "Unnamed Device")
                //self.peripheralIDs.append(peripheral.identifier.description)
            }
        }
        
    }
    
    func connectToDevice(_ peripheral: CBPeripheral) {
        obdSensorPeripheral = peripheral
        centralManager?.connect(obdSensorPeripheral!)
        peripheralStatus = .connecting
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralStatus = .connected
        print("Connected to \(peripheral)")
        
        peripheral.delegate = self
        peripheral.discoverServices([])
        centralManager?.stopScan()
        print("Stopped scanning for Bluetooth Devices")
    }
    
    // ****** PROBABLY DELTE *******
    // Made this, might not work, can delete
    func disconnectFromAdapter(_ peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(obdSensorPeripheral!)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheralStatus = .disconnected
        print("Disconnected from \(peripheral)")
        stopData = false
        
        //        scanForPeripherals()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        peripheralStatus = .error
        print(error?.localizedDescription ?? "no error")
    }
    
}

extension BluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            print("found service for \(service)")
            peripheral.discoverCharacteristics([], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if (String(describing: characteristic.uuid)) == "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F" {
                obdSensorCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                //                print("Found \(characteristic), waiting on values:")
                //                print("Characteristic Value: \(String(describing: characteristic.value))")
                
                if openedApp && populateData {
                    let char = characteristic
                    var counter = 3
                    print("made it into initializing Data")
                    
                    //                    let btTimer = Timer.publish(every: 1.5, tolerance: 0.5, on: .main, in: .common).autoconnect() { time in
                    //
                    //                    }
                    if dataParser.obdProtocol == "" {
                        // Requesting vehicle protocol
                        peripheral.writeValue(commands[2], for: char, type: CBCharacteristicWriteType.withResponse)
                        
                        peripheral.readValue(for: char)
                    }
                    
                    sendData = true
                    
                    print("made it past protocol check")
                    
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
                        
                        requestData(index: counter)
                        print("sent requestData \(counter)")
                        counter += 1
                        
                        if(counter == 10){
                            timer.invalidate()
                            print("timer invalidated!")
                            populateData = false
                            
                        }
                    }
                    
                    print("exited timer and initializing data")
                    
                }
                
                //                populateData = false
                openedApp = false
                //                sendData = true
                
            }
        }
    }
    
    func requestData(index: Int) {
        if ((obdSensorPeripheral?.canSendWriteWithoutResponse) != nil && sendData) {
            if index == 0 {
                var tempString = "01"
                
                for iter in 0...3 {
                    tempString.append(dataParser.liveData[iter].pidName)
                    //                    print("tempString in rData() \(tempString)")
                }
                tempString.append("\r\n")
                
                commands[0] = tempString.data(using: .utf8)!
            }
            
            //            print("Made it into items loop")
            if sendData {
                //                print("Made it into sendData check")
                self.write(value: commands[index], characteristic: self.obdSensorCharacteristic!)
                self.read(characteristic: self.obdSensorCharacteristic!)
                
                //                print("Sent item \(String(data:commands[index], encoding:.utf8)!) to \(String(describing: obdSensorCharacteristic))\n in the new peripheralIsReady()!")
            }
            
        }
    }
    
    // Function used to check if connected peripheral is ready to receive request
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("Checked peripheralIsReady()")
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("func Peripheral didUpdateValue() called")
        if let value = characteristic.value {
            //            print("Printing from PeripheralID: \(peripheral.identifier)\n and CharacteristicUUID: \(characteristic.uuid)")
            print(String(data:value, encoding:.utf8)!)
            
            dataParser.returnedString = String(data:value, encoding:.utf8) ?? "nil"
            
            dataParser.dataHolder = dataParser.returnedString.components(separatedBy: .whitespaces)
            
            if dataParser.dataHolder[0] != "41" && dataParser.dataHolder[0] != "00A" &&
                dataParser.dataHolder[0] != "00B" && dataParser.dataHolder[0] != "00C"
                && dataParser.dataHolder[0] != "009" {
                
                for item in dataParser.dataHolder {
                    if !item.contains("\r") && !item.contains("00") {
                        dataParser.displayData.append(item)
                    }
                }
                print("contents of displayData in beg. = \(dataParser.displayData)")
            }
            else {
                for item in dataParser.dataHolder {
                    if !item.contains("\r") {
                        dataParser.displayData.append(item)
                    }
                }
                print("contents of displayData in beg. = \(dataParser.displayData)")
            }
            
            
            dataParser.dataHolder.removeAll()
            
            // Decoding called for Request Response
            if dataParser.returnedString.hasPrefix("I") {
                dataParser.showProtocol(dataParser.returnedString)
            }
            
            // Decoding called for supported PIDs 01-20: 41 00 BF 9F E8 93
            if dataParser.returnedString.contains("41 00 ") ||
                dataParser.returnedString.contains("41 20 ") ||
                dataParser.returnedString.contains("41 40 ") ||
                dataParser.returnedString.contains("41 51 ") {
                
                //                print("*** Called supported PIDs ***")
                let realString = dataParser.returnedString.components(separatedBy:.whitespaces)
                var dataString = ""
                
                
                for item in realString {
                    if !item.contains("\r") {
                        dataString += item
                    }
                }
                print(dataString)
                dataParser.convertStringData(dataString)
            }
            
            // Decoding called for VIN: 4902013554464C5534454E364558303930303535
            if dataParser.returnedString.contains("014 ") {
                //                let mySubstring = dataParser.returnedString.suffix(69)
                //                let sendString = String(mySubstring)
                //                let realString = sendString.components(separatedBy:.whitespaces)
                //                var dataString = ""
                ////                dataParser.displayData.remove(at: 0)
                //
                //
                //                for item in realString {
                //                    if !item.contains("\r") {
                //                        dataString += item
                //                    }
                //                }
                //                print(dataString)
                //                dataParser.convertData(dataString)
                dataParser.displayData.remove(at: 0)
                dataParser.convertData(&dataParser.displayData)
            }
            
            // Decoding called for Calibration ID: 49040233303438323130304130433031303030
            if dataParser.returnedString.contains("023 ") {
                //                let mySubstring = dataParser.returnedString.suffix(147)
                //                let sendString = String(mySubstring)
                //                let realString = sendString.components(separatedBy:.whitespaces)
                //                var dataString = ""
                //                dataParser.displayData.remove(at: 0)
                //
                //
                //                for item in realString {
                //                    if !item.contains("00") && !item.contains("\r") {
                //                        dataString += item
                //                    }
                //                }
                //                print(dataString)
                //                dataParser.convertData(dataString)
                dataParser.displayData.remove(at: 0)
                dataParser.convertData(&dataParser.displayData)
            }
            
            // Decoding called for ECU name: 490A0145434D2D456E67696E65436F6E74726F6C
            if dataParser.returnedString.contains("017 ") {
                //                let mySubstring = dataParser.returnedString.suffix(94)
                //                let sendString = String(mySubstring)
                //                let realString = sendString.components(separatedBy:.whitespaces)
                //                var dataString = ""
                //                dataParser.displayData.remove(at: 0)
                //
                //
                //                for item in realString {
                //                    if !item.contains("00") && !item.contains("\r") {
                //                        dataString += item
                //                    }
                //                }
                //                print(dataString)
                //                dataParser.convertData(dataString)
                dataParser.displayData.remove(at: 0)
                dataParser.convertData(&dataParser.displayData)
            }
            
            // Decoding 4 sensor values at once
            if dataParser.returnedString.contains("00A ") || dataParser.returnedString.contains("00B ")
                || dataParser.returnedString.contains("009 ") {
                //                let mySubstring = dataParser.returnedString.suffix(45)
                //                let sendString = String(mySubstring)
                //                let realString = sendString.components(separatedBy:.whitespaces)
                //                var dataString = ""
                //                dataParser.displayData.remove(at: 0)
                //
                //
                //                for item in realString {
                //                    if !item.contains("\r") {
                //                        dataString += item
                //                    }
                //                }
                //                print(dataString)
                //                dataParser.convertData(dataString)
                if dataParser.displayData[1] == "43" {
                    dataParser.displayData.remove(at: 0)
                    var dataString = ""
                    
                    for item in dataParser.displayData {
                        if !item.contains("\r") || !item.contains("00") {
                            dataString += item
                        }
                    }
                    print("Inside 00C and prefix 43 ")
                    print(dataString)
                    
                    if dataString.count != 2 {
                        dataParser.convertStringData(dataString)
                    }
                }
                
                
                dataParser.displayData.remove(at: 0)
                dataParser.convertData(&dataParser.displayData)
            }
            
            // Decoding DTCs
            if dataParser.returnedString.contains("00C ") || dataParser.returnedString.hasPrefix("43 ") {
                if dataParser.displayData.count > 1 && dataParser.displayData[1] == "41" {
                    dataParser.displayData.remove(at: 0)
                    dataParser.convertData(&dataParser.displayData)
                }
                else if dataParser.displayData[0] == "43" {
                    var dataString = ""
                    
                    for item in dataParser.displayData {
                        if !item.contains("\r") || !item.contains("00") {
                            dataString += item
                        }
                    }
                    print("Inside 00C and prefix 43 ")
                    print(dataString)
                    
                    if dataString.count != 2 {
                        dataParser.convertStringData(dataString)
                    }
                }
                else {
                    let mySubstring = dataParser.returnedString.suffix(dataParser.returnedString.count - 3)
                    let sendString = String(mySubstring)
                    let realString = sendString.components(separatedBy:.whitespaces)
                    var dataString = ""
                    
                    
                    for item in realString {
                        if !item.contains("\r") {
                            dataString += item
                        }
                    }
                    print(dataString)
                    dataParser.convertStringData(dataString)
                    
                }
                
            }
            /* Response for multi-sensors need to compare to DTCs
             00C
             0: 41 10 00 3C 0C 00
             1: 00 42 30 4B 0F 67 00
             */
            /*
             When unplugged MAF and Throttle Body
             00C
             0: 43 05 01 02 01 13
             1: 01 21 01 23 21 35 00
             */
            
            if dataParser.returnedString.contains(">") {
                //                print("The dataParser contained the '>' I was looking for:")
                //                print(dataParser.returnedString)
                sendData = true
                //                print("Value of sendData = \(sendData)")
            }
        }
        
        //        print("**** displayData = \(dataParser.displayData)\n")
        dataParser.displayData.removeAll()
        //        print("Erased displayData")
        //        print("**** displayData = \(dataParser.displayData)\n")
        
        // ******************** MIGHT USE GUARD FROM BELOW ********************
        //        if characteristic.uuid == hallSensorCharacteristic {
        //            guard let data = characteristic.value else {
        //                print("No data received for \(characteristic.uuid.uuidString)")
        //                return
        //            }
        //
        //            let sensorData: Int = data.withUnsafeBytes { $0.pointee }
        //
        //            magnetValue = sensorData
        //        }
    }
    
}


