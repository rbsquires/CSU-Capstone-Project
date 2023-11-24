//
//  DataParser.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import Foundation

struct LiveData {
    var pidName: String
    var returnBytes: Int
    var description: String
    var data: Int
    
    init(pidName: String, returnBytes: Int, description: String, data: Int) {
        self.pidName = pidName
        self.returnBytes = returnBytes
        self.description = description
        self.data = data
    }
}

struct SupportedSensor: Hashable {
    var pidName: String
    var description: String
    var inUse: Bool
    
}

class DataParser: ObservableObject {
    @Published var supportedPIDList = [String](arrayLiteral: "0")
    @Published var myPIDList = [String](arrayLiteral: "04", "05", "0A", "0B", "0C", "0D", "0F", "10", "11", "42", "51")
    @Published var liveData = [LiveData]()
    @Published var liveSensors = [SupportedSensor]()
    @Published var displayData = [String]()
    @Published var dtcData = [String]()
    @Published var returnedString: String = ""
    @Published var vinNumber: String = ""
    @Published var calibrationID: String = ""
    @Published var ecuName: String = ""
    @Published var obdProtocol: String = ""
    @Published var vehicleInfo0: LiveData = LiveData(pidName: "05", returnBytes: 1, description: "Engine Coolant Temp.", data: 0)
    @Published var vehicleInfo1: LiveData = LiveData(pidName: "0C", returnBytes: 2, description: "Engine Speed", data: 0)
    @Published var vehicleInfo2: LiveData = LiveData(pidName: "42", returnBytes: 2, description: "Battery Voltage", data: 0)
    @Published var vehicleInfo3: LiveData = LiveData(pidName: "10", returnBytes: 2, description: "MAF Flow Rate", data: 0)
    @Published var fuelType: String = ""
    private var returnedData = [Int](arrayLiteral: 0, 0, 0, 0)
    private var digitHolder: Int16 = 0
    private var decValHolder1: Int = 0
    private var decValHolder2: Int = 0
    private var decValHolder3: Int = 0
    private var decValHolder4: Int = 0
    private var decValHolder5: Int = 0
    private var charHolder: String = ""
    var dataHolder = [String]()
    //    var tempString: String = ""
    
    
    let PIDBytes = [
        "04": 1,
        "05": 1,
        "0A": 1,
        "0B": 1,
        "0C": 2,
        "0D": 1,
        "0F": 1,
        "10": 2,
        "11": 1,
        "42": 2,
        "51": 1
    ]
    
    let PIDTypes = [
        "04": "%",
        "05": "°F",
        "0A": "psi",
        "0B": "psi",
        "0C": "RPM",
        "0D": "MPH",
        "0F": "°F",
        "10": "g/s",
        "11": "%",
        "42": "V",
        "51": "FuelType"
    ]
    
    let PIDDescription = [
        "04": "Engine Load",
        "05": "Engine Coolant Temp.",
        "0A": "Fuel Pressure",
        "0B": "Intake Man. Pressure",
        "0C": "Engine Speed",
        "0D": "Vehicle Speed",
        "0F": "Intake Air Temp.",
        "10": "MAF Flow Rate",
        "11": "Throttle Position",
        "42": "Battery Voltage",
        "51": "FuelType"
    ]
    
    func populateLiveData() {
        liveData.append(vehicleInfo0)
        liveData.append(vehicleInfo1)
        liveData.append(vehicleInfo2)
        liveData.append(vehicleInfo3)
    }
    
    func populateLiveSensor() {
        //        print("*********** populateLiveSensor() ***********")
        liveSensors.removeAll()
        print("contents of supportedPIDList = \(supportedPIDList)")
        for index in 1..<supportedPIDList.count {
            //            print("MADE IT INTO FOR LOOP")
            let hexIndex = String(format:"%02X", index)
            print("hexIndex = \(hexIndex)")
            if supportedPIDList[index] == "1" && myPIDList.contains(hexIndex) && hexIndex != "51" {
                //                print("****** MADE IT INTO MY POPULATELIVESENSOR() IF STATEMENT ******")
                // If it is being monitored
                if liveData[0].pidName == hexIndex || liveData[1].pidName == hexIndex ||
                    liveData[2].pidName == hexIndex || liveData[3].pidName == hexIndex {
                    
                    liveSensors.append(SupportedSensor(pidName: hexIndex, description: PIDDescription[hexIndex] ?? "Nil", inUse: true))
                }
                else {
                    liveSensors.append(SupportedSensor(pidName: hexIndex, description: PIDDescription[hexIndex] ?? "Nil", inUse: false))
                }
            }
        }
        
        //        liveSensors.append(SupportedSensor(pidName: "42", description: PIDDescription["42"] ?? "Nil", inUse: true))
        
        print("Contents of liveSensors = \(liveSensors)")
    }
    
    // Pass in the PID for the sensor that is being swapped out
    func swapInUseForNewSensor(_ pid: String) {
        for var iter in liveSensors {
            if iter.pidName == pid {
                iter.inUse = false
            }
        }
    }
    
    func convertData(_ data: inout [String]) {
        switch data[0] {
        case "41":
            //            print("Mode 1:")
            if data[1] == "00" {
                // Call parser for supported PIDs and clear displayData[]
            }
            else if data[1] == "51" {
                // Set fuel type from [2] and then clear displayData[]
                //                print("Fuel Type")
                if data[2] == "01" {
                    fuelType = "Gasoline"
                }
                
                displayData.removeAll()
            }
            else {
                // Need to figure out how to parse data by PID byte size, then all calculation for that number, then pare the next one
                //                print("data in Mode1 = \(data)")
                data.remove(at: 0)
                var index = 0
                
                while index < 4 {
                    
                    let numberBytes = dataByteSize(data[0])
                    let pid = data[0]
                    decValHolder1 = Int(data[1], radix: 16) ?? 0
                    //                    var calcType = ""
                    
                    if numberBytes == 1 {
                        callCalculation(pid, index, decValHolder1, 0)
                        
                        data.remove(at: 1)
                        data.remove(at: 0)
                    }
                    else {
                        decValHolder2 = Int(data[2], radix: 16) ?? 0
                        callCalculation(pid, index, decValHolder1, decValHolder2)
                        data.remove(at: 2)
                        data.remove(at: 1)
                        data.remove(at: 0)
                    }
                    
                    index += 1
                }
                //                print("data after removes = \(data)")
                data.removeAll()
            }
            
        case "43":
            //            print("Mode 3:")
            
            for item in data {
                displayData.append(String(item))
            }
            
            //            print("display data in Mode 3 case: \(displayData)")
            
        case "49":
            //            print("Mode 9:")
            // Calibration ID 49040233303438323130304130433031303030
            if data[1] == "04" {
                //                print("Made it into Mode 9 (04)")
                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)
                //                let tempSubstring = String(data.suffix(32))
                var tempString = ""
                //                print("tempSubstring = \(tempSubstring)")
                
                for item in data {
                    //                    print("*** item = \(item) ***")
                    //                    charHolder += String(item)
                    decValHolder1 = Int(item, radix: 16) ?? -1
                    //                    calibrationID.append(String(decValHolder1))
                    
                    //                    print("decValHolder = \(decValHolder1)")
                    
                    let char = Character(UnicodeScalar(decValHolder1)!)
                    
                    //                    print("char = \(char)")
                    
                    tempString += String(char)
                    
                }
                
                calibrationID = tempString
                tempString = ""
                print("calibrationID: \(calibrationID)")
            }
            // ECU name 490A0145434D2D456E67696E65436F6E74726F6C
            else if data[1] == "0A" {
                //                print("Made it into Mode 9 (0A)")
                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)
                
                var tempString = ""
                
                for item in data {
                    //                    print("*** item = \(item) ***")
                    //                    charHolder += String(item)
                    decValHolder1 = Int(item, radix: 16) ?? -1
                    //                    calibrationID.append(String(decValHolder1))
                    //                    decValHolder1 = Int(charHolder, radix: 16) ?? 0
                    
                    //                    print("decValHolder = \(decValHolder1)")
                    if decValHolder1 != -1 {
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        //                    print("char = \(char)")
                        
                        tempString += String(char)
                        
                    }
                    
                }
                
                ecuName = tempString
                tempString = ""
                print("ecuName: \(ecuName)")
            }
            
            else if data[1] == "02" {
                //                print("Made it into Mode 9 (0A)")
                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)
                
                var tempString = ""
                
                for item in data {
                    //                    print("*** item = \(item) ***")
                    //                    charHolder += String(item)
                    decValHolder1 = Int(item, radix: 16) ?? -1
                    //                    calibrationID.append(String(decValHolder1))
                    //                    decValHolder1 = Int(charHolder, radix: 16) ?? 0
                    
                    //                    print("decValHolder = \(decValHolder1)")
                    
                    let char = Character(UnicodeScalar(decValHolder1)!)
                    
                    //                    print("char = \(char)")
                    
                    tempString += String(char)
                    
                }
                
                vinNumber = tempString
                tempString = ""
                //                print("ecuName: \(vinNumber)")
            }
            //            else {
            //                let tempSubstring = String(data.suffix(34))
            //                var tempString = ""
            //                print("tempSubstring = \(tempSubstring)")
            //
            //                for item in tempSubstring {
            //                    charHolder += String(item)
            //
            //                    if charHolder.count == 2 {
            //                        print("charHolder = \(charHolder)")
            //
            //                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
            //
            //                        print("decValHolder = \(decValHolder1)")
            //
            //                        let char = Character(UnicodeScalar(decValHolder1)!)
            //
            //                        print("char = \(char)")
            //
            //                        tempString += String(char)
            //
            //                        charHolder = ""
            //
            //                    }
            //                }
            //                vinNumber = tempString
            //                tempString = ""
            //                print("VIN: \(vinNumber)")
            //
            //            }
            
        default:
            print("***** No case was Found for return data *****")
        }
        
        //        print("returned Data = \(returnedData)")
        liveData[0].data = returnedData[0]
        liveData[1].data = returnedData[1]
        liveData[2].data = returnedData[2]
        liveData[3].data = returnedData[3]
        
    }
    
    func convertStringData (_ data: String) {
        switch data[1] {
        case "1":
            //            print("Mode 1:")
            var tempString = ""
            var tempString2 = ""
            var tempString3 = ""
            var tempString4 = ""
            var tempString5 = ""
            
            if data[2] == "5" && data[3] == "1" {
                if data[4] == "0" && data[5] == "1" {
                    fuelType = "Gasoline"
                }
                else if data[6] == "0" && data[7] == "4" {
                    fuelType = "Diesel"
                }
            }
            // 1011 1111 1001 1111 1110 1000 1001 0011
            else if (data[2] == "0" && data[3] == "0") || (data[2] == "2" && data[3] == "0")
                        || (data[2] == "4" && data[3] == "0") {
                //                print("supportedPIDList = \(supportedPIDList)")
                var tempSubstring = String(data.suffix(data.count - 4))
                var counter = 2
                
                //                print("*** counter = \(counter) ***")
                
                while counter > 0 && tempSubstring.count > 0 {
                    //                    print("in while loop tempSubstring2 = \(tempSubstring)")
                    let tempByte1 = Int(tempSubstring[0], radix: 16) ?? 0
                    let tempByte1String = String(tempByte1, radix: 2)
                    let tempByte2 = Int(tempSubstring[1], radix: 16) ?? 0
                    let tempByte2String = String(tempByte2, radix: 2)
                    let tempByte3 = Int(tempSubstring[2], radix: 16) ?? 0
                    let tempByte3String = String(tempByte3, radix: 2)
                    let tempByte4 = Int(tempSubstring[3], radix: 16) ?? 0
                    let tempByte4String = String(tempByte4, radix: 2)
                    var outputString = ""
                    
                    //                    print("tempBytes Strings = \(tempByte1String) \(tempByte2String) \(tempByte3String) \(tempByte4String)")
                    
                    switch (tempByte1String) {
                    case "0":
                        outputString.append("0000")
                    case "1":
                        outputString.append("0001")
                    case "10":
                        outputString.append("0010")
                    case "11":
                        outputString.append("0011")
                    case "100":
                        outputString.append("0100")
                    case "101":
                        outputString.append("0101")
                    case "110":
                        outputString.append("0110")
                    case "111":
                        outputString.append("0111")
                    case "1000":
                        outputString.append("1000")
                    case "1001":
                        outputString.append("1001")
                    case "1010":
                        outputString.append("1010")
                    case "1011":
                        outputString.append("1011")
                    case "1100":
                        outputString.append("1100")
                    case "1101":
                        outputString.append("1101")
                    case "1110":
                        outputString.append("1110")
                    case "1111":
                        outputString.append("1111")
                    default:
                        print("No case found for tempByte1String")
                    }
                    
                    switch (tempByte2String) {
                    case "0":
                        outputString.append("0000")
                    case "1":
                        outputString.append("0001")
                    case "10":
                        outputString.append("0010")
                    case "11":
                        outputString.append("0011")
                    case "100":
                        outputString.append("0100")
                    case "101":
                        outputString.append("0101")
                    case "110":
                        outputString.append("0110")
                    case "111":
                        outputString.append("0111")
                    case "1000":
                        outputString.append("1000")
                    case "1001":
                        outputString.append("1001")
                    case "1010":
                        outputString.append("1010")
                    case "1011":
                        outputString.append("1011")
                    case "1100":
                        outputString.append("1100")
                    case "1101":
                        outputString.append("1101")
                    case "1110":
                        outputString.append("1110")
                    case "1111":
                        outputString.append("1111")
                    default:
                        print("No case found for tempByte2String")
                    }
                    
                    switch (tempByte3String) {
                    case "0":
                        outputString.append("0000")
                    case "1":
                        outputString.append("0001")
                    case "10":
                        outputString.append("0010")
                    case "11":
                        outputString.append("0011")
                    case "100":
                        outputString.append("0100")
                    case "101":
                        outputString.append("0101")
                    case "110":
                        outputString.append("0110")
                    case "111":
                        outputString.append("0111")
                    case "1000":
                        outputString.append("1000")
                    case "1001":
                        outputString.append("1001")
                    case "1010":
                        outputString.append("1010")
                    case "1011":
                        outputString.append("1011")
                    case "1100":
                        outputString.append("1100")
                    case "1101":
                        outputString.append("1101")
                    case "1110":
                        outputString.append("1110")
                    case "1111":
                        outputString.append("1111")
                    default:
                        print("No case found for tempByte3String")
                    }
                    
                    switch (tempByte4String) {
                    case "0":
                        outputString.append("0000")
                    case "1":
                        outputString.append("0001")
                    case "10":
                        outputString.append("0010")
                    case "11":
                        outputString.append("0011")
                    case "100":
                        outputString.append("0100")
                    case "101":
                        outputString.append("0101")
                    case "110":
                        outputString.append("0110")
                    case "111":
                        outputString.append("0111")
                    case "1000":
                        outputString.append("1000")
                    case "1001":
                        outputString.append("1001")
                    case "1010":
                        outputString.append("1010")
                    case "1011":
                        outputString.append("1011")
                    case "1100":
                        outputString.append("1100")
                    case "1101":
                        outputString.append("1101")
                    case "1110":
                        outputString.append("1110")
                    case "1111":
                        outputString.append("1111")
                    default:
                        print("No case found for tempByte4String")
                    }
                    
                    print("outputString = \(outputString)")
                    for item in outputString {
                        supportedPIDList.append(String(item))
                    }
                    counter -= 1
                    tempSubstring = String(tempSubstring.suffix(tempSubstring.count - 4))
                    //                    supportedPIDList.append(outputString)
                }
                
                //                print("supportedPIDList = \(supportedPIDList)")
                //                print("display data in Mode 3 case: \(displayData)")
                populateLiveSensor()
                //                print("Just called populateLiveSensor()")
            }
            else {
                for(index, char) in data.enumerated() {
                    if index == 4 || index == 5 {
                        tempString.append(char)
                        
                        if tempString.count == 2 {
                            //                            print(" 01 tempString = \(tempString)")
                            decValHolder1 = Int(tempString, radix: 16) ?? 0
                            //                            print(" 01 decValHolder = \(decValHolder1)")
                        }
                    }
                    
                    if index == 8 || index == 9 {
                        tempString2.append(char)
                        
                        if tempString2.count == 2 {
                            //                            print(" 01 tempString2 = \(tempString2)")
                            decValHolder2 = Int(tempString2, radix: 16) ?? 0
                            //                            print(" 01 decValHolder2 = \(decValHolder2)")
                        }
                    }
                    
                    if index == 10 || index == 11 {
                        tempString3.append(char)
                        
                        if tempString3.count == 2 {
                            //                            print(" 01 tempString3 = \(tempString3)")
                            decValHolder3 = Int(tempString3, radix: 16) ?? 0
                            //                            print(" 01 decValHolder3 = \(decValHolder3)")
                        }
                    }
                    
                    if index == 14 || index == 15 {
                        tempString4.append(char)
                        
                        if tempString4.count == 2 {
                            //                            print(" 01 tempString4 = \(tempString4)")
                            decValHolder4 = Int(tempString4, radix: 16) ?? 0
                            //                            print(" 01 decValHolder4 = \(decValHolder4)")
                        }
                    }
                    
                    if index == 18 || index == 19 {
                        tempString5.append(char)
                        
                        if tempString5.count == 2 {
                            //                            print(" 01 tempString5 = \(tempString5)")
                            decValHolder5 = Int(tempString5, radix: 16) ?? 0
                            //                            print(" 01 decValHolder5 = \(decValHolder5)")
                        }
                    }
                }
            }
            //            print("post case: decValHolder = \(decValHolder1)")
            
        case "3":
            print("Mode 3:")
            // 43 02 01 02 01 13 response for MAF unplugged
            // Hex to binary conversion 13 = 00010011
            // 01 02 = 0000 0001 0000 0010
            //         P  0   1    0    2
            // 01 13 = 0000 0001 0001 0011
            //         P  0   1    1    3
            
            /* q
             
             43 05 01 02 01 13 01 21 01 23 21 35 00
             01 02 = 0000 0001 0000 0010
             P  0   1    0    2
             01 13 = 0000 0001 0001 0011
             P  0   1    1    3
             01 21 = 0000 0001 0010 0001
             P  0   1    2    1
             01 23 = 0000 0001 0010 0011
             P  0   1    2    3
             21 35 = 0010 0001 0011 0101
             P  2   1    3    5
             */
            
            var tempSubstring = String(data.suffix(data.count - 2))
            var tempString = ""
            print("tempSubstring = \(tempSubstring)")
            
            for iter in 0...1 {
                tempString.append(tempSubstring[iter])
            }
            var counter = Int(tempString, radix: 16) ?? 0
            tempString = ""
            //            print("*** counter = \(counter) ***")
            tempSubstring = String(tempSubstring.suffix(tempSubstring.count - 2))
            
            while counter > 0 && tempSubstring.count > 4 {
                //                print("in while loop tempSubstring2 = \(tempSubstring)")
                let tempByte1 = Int(tempSubstring[0], radix: 16) ?? 0
                let tempByte1String = String(tempByte1, radix: 2)
                let tempByte2 = Int(tempSubstring[1], radix: 16) ?? 0
                let tempByte2String = String(tempByte2, radix: 2)
                let tempByte3 = Int(tempSubstring[2], radix: 16) ?? 0
                let tempByte3String = String(tempByte3, radix: 2)
                let tempByte4 = Int(tempSubstring[3], radix: 16) ?? 0
                let tempByte4String = String(tempByte4, radix: 2)
                var outputString = ""
                
                //                print("tempBytes Strings = \(tempByte1String) \(tempByte2String) \(tempByte3String) \(tempByte4String)")
                
                switch (tempByte1String) {
                case "0":
                    outputString.append("P0")
                case "1":
                    outputString.append("P1")
                case "10":
                    outputString.append("P2")
                case "11":
                    outputString.append("P3")
                case "100":
                    outputString.append("C0")
                case "101":
                    outputString.append("C1")
                case "110":
                    outputString.append("C2")
                case "111":
                    outputString.append("C3")
                case "1000":
                    outputString.append("B0")
                case "1001":
                    outputString.append("B1")
                case "1010":
                    outputString.append("B2")
                case "1011":
                    outputString.append("B3")
                case "1100":
                    outputString.append("U0")
                case "1101":
                    outputString.append("U1")
                case "1110":
                    outputString.append("U2")
                case "1111":
                    outputString.append("U3")
                default:
                    print("No case found for tempByte1String")
                }
                
                switch (tempByte2String) {
                case "0":
                    outputString.append("0")
                case "1":
                    outputString.append("1")
                case "10":
                    outputString.append("2")
                case "11":
                    outputString.append("3")
                case "100":
                    outputString.append("4")
                case "0101":
                    outputString.append("5")
                case "0110":
                    outputString.append("6")
                case "0111":
                    outputString.append("7")
                case "1000":
                    outputString.append("8")
                case "1001":
                    outputString.append("9")
                case "1010":
                    outputString.append("A")
                case "1011":
                    outputString.append("B")
                case "1100":
                    outputString.append("C")
                case "1101":
                    outputString.append("D")
                case "1110":
                    outputString.append("E")
                case "1111":
                    outputString.append("F")
                default:
                    print("No case found for tempByte2String")
                }
                
                switch (tempByte3String) {
                case "0":
                    outputString.append("0")
                case "1":
                    outputString.append("1")
                case "10":
                    outputString.append("2")
                case "11":
                    outputString.append("3")
                case "100":
                    outputString.append("4")
                case "101":
                    outputString.append("5")
                case "110":
                    outputString.append("6")
                case "111":
                    outputString.append("7")
                case "1000":
                    outputString.append("8")
                case "1001":
                    outputString.append("9")
                case "1010":
                    outputString.append("A")
                case "1011":
                    outputString.append("B")
                case "1100":
                    outputString.append("C")
                case "1101":
                    outputString.append("D")
                case "1110":
                    outputString.append("E")
                case "1111":
                    outputString.append("F")
                default:
                    print("No case found for tempByte3String")
                }
                
                switch (tempByte4String) {
                case "0":
                    outputString.append("0")
                case "1":
                    outputString.append("1")
                case "10":
                    outputString.append("2")
                case "11":
                    outputString.append("3")
                case "100":
                    outputString.append("4")
                case "101":
                    outputString.append("5")
                case "110":
                    outputString.append("6")
                case "111":
                    outputString.append("7")
                case "1000":
                    outputString.append("8")
                case "1001":
                    outputString.append("9")
                case "1010":
                    outputString.append("A")
                case "1011":
                    outputString.append("B")
                case "1100":
                    outputString.append("C")
                case "1101":
                    outputString.append("D")
                case "1110":
                    outputString.append("E")
                case "1111":
                    outputString.append("F")
                default:
                    print("No case found for tempByte4String")
                }
                
                counter -= 1
                tempSubstring = String(tempSubstring.suffix(tempSubstring.count - 4))
                dtcData.append(outputString)
            }
            
            print("display data in Mode 3 case: \(displayData)")
            
        case "9":
            //            print("Mode 9:")
            
            if data[3] == "4" {
                let tempSubstring = String(data.suffix(32))
                var tempString = ""
                //                print("tempSubstring = \(tempSubstring)")
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        //                        print("charHolder = \(charHolder)")
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
                        
                        //                        print("decValHolder = \(decValHolder1)")
                        
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        //                        print("char = \(char)")
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                calibrationID = tempString
                tempString = ""
                //                print("calibrationID: \(calibrationID)")
            }
            else if data[3] == "A" {
                let tempSubstring = String(data.suffix(36))
                var tempString = ""
                //                print("tempSubstring = \(tempSubstring)")
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        //                        print("charHolder = \(charHolder)")
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
                        
                        //                        print("decValHolder = \(decValHolder1)")
                        
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        //                        print("char = \(char)")
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                ecuName = tempString
                tempString = ""
                //                print("ecuName: \(ecuName)")
            }
            else {
                let tempSubstring = String(data.suffix(34))
                var tempString = ""
                //                print("tempSubstring = \(tempSubstring)")
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        //                        print("charHolder = \(charHolder)")
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
                        
                        //                        print("decValHolder = \(decValHolder1)")
                        
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        //                        print("char = \(char)")
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                vinNumber = tempString
                tempString = ""
                //                print("VIN: \(vinNumber)")
                
            }
            
            
            //            print("Asked for Vehicle Info (Ex: VIN)")
            //            vinNumber = tempString
            //            tempString = ""
            //            print("VIN: \(vinNumber)")
            
            
            
        default:
            print("No case was Found for return data")
        }
        
        
        
        //        print("Value held in monitor1Data (after for) = \(monitor1Data)\n")
        //        print("**** displayData = \(displayData)\n")
        //        displayData.removeAll()
        //        print("intData = \(intData)\n")
        //        print("returnedString = \(returnedString)")
        
        //        vehicleInfo1 = 0.0
        returnedString = ""
    }
    
    func dataByteSize(_ pid: String) -> Int {
        // Need to make a type that has PID and number of data bytes returned, then look it up here, and return that number of bytes
        
        return PIDBytes[pid] ?? 0
    }
    
    // ****** MAY NOT NEED ******
    func parseOneBytePID(_ data: [String]) {
        
    }
    // ****** MAY NOT NEED ******
    func parseTwoBytePID(_ data: [String]) {
        
    }
    
    // Used to call the appropriate calculation per PID
    func callCalculation(_ pid: String, _ index: Int, _ int1: Int, _ int2: Int) {
        switch pid {
        case "04":
            print("Mode EngineLoad:")
            returnedData[index] = calculatePercentage(int1)
            
        case "05":
            print("Mode WaterTemp:")
            returnedData[index] = calculateTemp(int1)
            
        case "0A":
            print("Mode FuelPressure:")
            returnedData[index] = calculateFuelPressure(int1)
            
        case "0B":
            print("Mode IntakeMan.Pressure:")
            returnedData[index] = calculatePressure(int1)
            
        case "0C":
            print("Mode EngineSpeed:")
            returnedData[index] = calculateEngineSpeed(int1, int2)
            
        case "0D":
            print("Mode VehicleSpeed:")
            returnedData[index] = calculateVehicleSpeed(int1)
            
        case "0F":
            print("Mode IntakeAirTemp:")
            returnedData[index] = calculateTemp(int1)
            
        case "10":
            print("Mode MAF-rate:")
            returnedData[index] = calculateMAF(int1, int2)
            
        case "11":
            print("Mode ThrottlePos:")
            returnedData[index] = calculatePercentage(int1)
            
        case "42":
            print("Mode ECUvolts:")
            returnedData[index] = calculateVoltage(int1, int2)
            
        default:
            print("***** No case was Found for return data *****")
        }
    }
    
    func showProtocol(_ data: String) {
        if data.contains("ISO 15765-4 (CAN 11/500)") {
            obdProtocol = "ISO 15765-4 (CAN 11bit / 500kbaud)"
        }
        returnedString = ""
    }
    
    func calculatePressure(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt * 0.145038)
        
    }
    
    func calculateFuelPressure(_ int: Int) -> Int {
        let tempInt = Double(int * 3)
        
        return Int(tempInt * 0.145038)
        
    }
    
    func calculateTemp(_ int: Int) -> Int {
        let tempInt = Double(int - 40)
        
        return Int((tempInt * 1.8) + 32)
        
    }
    
    func calculateMAF(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        
        //        return Int((((256 * tempInt1) + tempInt2) / 100) * 0.002205)
        return Int(((256 * tempInt1) + tempInt2) / 100)
    }
    
    func calculatePercentage(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt / 2.55)
    }
    
    func calculateVoltage(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        
        return Int(((256 * tempInt1) + tempInt2) / 1000)
    }
    
    func calculateVehicleSpeed(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt / 1.6093440006147)
    }
    
    func calculateEngineSpeed(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        
        return Int(((256 * tempInt1) + tempInt2) / 4)
    }
    
}

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}



