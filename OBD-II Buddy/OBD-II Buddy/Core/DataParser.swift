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
    
    // Function used to populate array with sensor info
    func populateLiveData() {
        liveData.append(vehicleInfo0)
        liveData.append(vehicleInfo1)
        liveData.append(vehicleInfo2)
        liveData.append(vehicleInfo3)
    }
    
    // Function used to populate which sensors are shown and sort their data to be displayed
    func populateLiveSensor() {
        liveSensors.removeAll()
        print("contents of supportedPIDList = \(supportedPIDList)")
        for index in 1..<supportedPIDList.count {
            let hexIndex = String(format:"%02X", index)
            print("hexIndex = \(hexIndex)")
            if supportedPIDList[index] == "1" && myPIDList.contains(hexIndex) && hexIndex != "51" {

                // If sensor is being monitored
                if liveData[0].pidName == hexIndex || liveData[1].pidName == hexIndex ||
                    liveData[2].pidName == hexIndex || liveData[3].pidName == hexIndex {
                    
                    liveSensors.append(SupportedSensor(pidName: hexIndex, description: PIDDescription[hexIndex] ?? "Nil", inUse: true))
                }
                else {
                    liveSensors.append(SupportedSensor(pidName: hexIndex, description: PIDDescription[hexIndex] ?? "Nil", inUse: false))
                }
            }
        }
        
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
    
    // Function used to convert hex data returned from the ECU
    func convertData(_ data: inout [String]) {
        switch data[0] {
        case "41":

            if data[1] == "00" {
                // Call parser for supported PIDs and clear displayData[]
            }
            else if data[1] == "51" {
                // Set fuel type from [2] and then clear displayData[]
                if data[2] == "01" {
                    fuelType = "Gasoline"
                }
                
                displayData.removeAll()
            }
            else {
                data.remove(at: 0)
                var index = 0
                
                while index < 4 {
                    
                    let numberBytes = dataByteSize(data[0])
                    let pid = data[0]
                    decValHolder1 = Int(data[1], radix: 16) ?? 0
                    
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

                data.removeAll()
            }
            
        case "43":
            
            for item in data {
                displayData.append(String(item))
            }
            
        case "49":

            if data[1] == "04" {
                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)

                var tempString = ""
                
                for item in data {

                    decValHolder1 = Int(item, radix: 16) ?? -1
                    
                    let char = Character(UnicodeScalar(decValHolder1)!)
                
                    tempString += String(char)
                    
                }
                
                calibrationID = tempString
                tempString = ""
                print("calibrationID: \(calibrationID)")
            }
            else if data[1] == "0A" {

                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)
                
                var tempString = ""
                
                for item in data {

                    decValHolder1 = Int(item, radix: 16) ?? -1

                    if decValHolder1 != -1 {
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        tempString += String(char)
                        
                    }
                }
                
                ecuName = tempString
                tempString = ""
                print("ecuName: \(ecuName)")
            }
            
            else if data[1] == "02" {

                data.remove(at: 2)
                data.remove(at: 1)
                data.remove(at: 0)
                
                var tempString = ""
                
                for item in data {

                    decValHolder1 = Int(item, radix: 16) ?? -1
                    
                    let char = Character(UnicodeScalar(decValHolder1)!)
                    
                    tempString += String(char)
                    
                }
                
                vinNumber = tempString
                tempString = ""
            }
        default:
            print("***** No case was Found for return data *****")
        }

        liveData[0].data = returnedData[0]
        liveData[1].data = returnedData[1]
        liveData[2].data = returnedData[2]
        liveData[3].data = returnedData[3]
        
    }
    
    func convertStringData (_ data: String) {
        switch data[1] {
        case "1":

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
            else if (data[2] == "0" && data[3] == "0") || (data[2] == "2" && data[3] == "0")
                        || (data[2] == "4" && data[3] == "0") {

                var tempSubstring = String(data.suffix(data.count - 4))
                var counter = 2
                
                while counter > 0 && tempSubstring.count > 0 {

                    let tempByte1 = Int(tempSubstring[0], radix: 16) ?? 0
                    let tempByte1String = String(tempByte1, radix: 2)
                    let tempByte2 = Int(tempSubstring[1], radix: 16) ?? 0
                    let tempByte2String = String(tempByte2, radix: 2)
                    let tempByte3 = Int(tempSubstring[2], radix: 16) ?? 0
                    let tempByte3String = String(tempByte3, radix: 2)
                    let tempByte4 = Int(tempSubstring[3], radix: 16) ?? 0
                    let tempByte4String = String(tempByte4, radix: 2)
                    var outputString = ""
                    
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

                }

                populateLiveSensor()

            }
            else {
                for(index, char) in data.enumerated() {
                    if index == 4 || index == 5 {
                        tempString.append(char)
                        
                        if tempString.count == 2 {

                            decValHolder1 = Int(tempString, radix: 16) ?? 0

                        }
                    }
                    
                    if index == 8 || index == 9 {
                        tempString2.append(char)
                        
                        if tempString2.count == 2 {

                            decValHolder2 = Int(tempString2, radix: 16) ?? 0

                        }
                    }
                    
                    if index == 10 || index == 11 {
                        tempString3.append(char)
                        
                        if tempString3.count == 2 {

                            decValHolder3 = Int(tempString3, radix: 16) ?? 0

                        }
                    }
                    
                    if index == 14 || index == 15 {
                        tempString4.append(char)
                        
                        if tempString4.count == 2 {

                            decValHolder4 = Int(tempString4, radix: 16) ?? 0

                        }
                    }
                    
                    if index == 18 || index == 19 {
                        tempString5.append(char)
                        
                        if tempString5.count == 2 {

                            decValHolder5 = Int(tempString5, radix: 16) ?? 0

                        }
                    }
                }
            }
            
        case "3":
            print("Mode 3:")
            
            
            var tempSubstring = String(data.suffix(data.count - 2))
            var tempString = ""
            print("tempSubstring = \(tempSubstring)")
            
            for iter in 0...1 {
                tempString.append(tempSubstring[iter])
            }
            var counter = Int(tempString, radix: 16) ?? 0
            tempString = ""
            tempSubstring = String(tempSubstring.suffix(tempSubstring.count - 2))
            
            while counter > 0 && tempSubstring.count > 4 {

                let tempByte1 = Int(tempSubstring[0], radix: 16) ?? 0
                let tempByte1String = String(tempByte1, radix: 2)
                let tempByte2 = Int(tempSubstring[1], radix: 16) ?? 0
                let tempByte2String = String(tempByte2, radix: 2)
                let tempByte3 = Int(tempSubstring[2], radix: 16) ?? 0
                let tempByte3String = String(tempByte3, radix: 2)
                let tempByte4 = Int(tempSubstring[3], radix: 16) ?? 0
                let tempByte4String = String(tempByte4, radix: 2)
                var outputString = ""
                
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
            
            if data[3] == "4" {
                let tempSubstring = String(data.suffix(32))
                var tempString = ""
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0

                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                calibrationID = tempString
                tempString = ""
                
            }
            else if data[3] == "A" {
                let tempSubstring = String(data.suffix(36))
                var tempString = ""
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
                        
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                ecuName = tempString
                tempString = ""

            }
            else {
                let tempSubstring = String(data.suffix(34))
                var tempString = ""
                
                for item in tempSubstring {
                    charHolder += String(item)
                    
                    if charHolder.count == 2 {
                        
                        decValHolder1 = Int(charHolder, radix: 16) ?? 0
                        
                        let char = Character(UnicodeScalar(decValHolder1)!)
                        
                        tempString += String(char)
                        
                        charHolder = ""
                        
                    }
                }
                vinNumber = tempString
                tempString = ""
                
            }

        default:
            print("No case was Found for return data")
        }

        returnedString = ""
    }
    
    // Function used to return the number of bytes returned for a PID
    func dataByteSize(_ pid: String) -> Int {
        
        return PIDBytes[pid] ?? 0
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
    
    // Function used to set the OBD-II protocol
    func showProtocol(_ data: String) {
        if data.contains("ISO 15765-4 (CAN 11/500)") {
            obdProtocol = "ISO 15765-4 (CAN 11bit / 500kbaud)"
        }
        returnedString = ""
    }
    
    // Function used to calculate pressure from
    func calculatePressure(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt * 0.145038)
        
    }
    
    // Function used to calculate fuel pressure from
    func calculateFuelPressure(_ int: Int) -> Int {
        let tempInt = Double(int * 3)
        
        return Int(tempInt * 0.145038)
        
    }
     // Function used to calculate temperature in F
    func calculateTemp(_ int: Int) -> Int {
        let tempInt = Double(int - 40)
        
        return Int((tempInt * 1.8) + 32)
        
    }
    
    // Function used to calculate MAF sensor air flow rate g/s
    func calculateMAF(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        //        lbs/hr calculation - too small a number to show at idle
        //        return Int((((256 * tempInt1) + tempInt2) / 100) * 0.002205)
        return Int(((256 * tempInt1) + tempInt2) / 100)
    }
    
    // Function used to calculate %
    func calculatePercentage(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt / 2.55)
    }
    
    // Function used to calculate voltage of the ECU
    func calculateVoltage(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        
        return Int(((256 * tempInt1) + tempInt2) / 1000)
    }
    
    // Function used to calculate vehicle speed in MPH
    func calculateVehicleSpeed(_ int: Int) -> Int {
        let tempInt = Double(int)
        
        return Int(tempInt / 1.6093440006147)
    }
    
    // Function used to calculate engine speed in RPM
    func calculateEngineSpeed(_ intA: Int, _ intB: Int) -> Int {
        let tempInt1 = Double(intA)
        let tempInt2 = Double(intB)
        
        return Int(((256 * tempInt1) + tempInt2) / 4)
    }
    
}

// Extension to help parse string data
extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}



