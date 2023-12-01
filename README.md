# OBD-II Buddy
#### **iOS/iPadOS 17.0+ is required to run this application*

This application will allow you connect to your vehicle's OBD-II port via Bluetooth BLE adapter, using your Apple Devices (iPhone & iPad) to read information such as:
- Engine RPM
- Coolant Temperature
- Battery Voltage
- Engine Load
- Throttle Position

## Compile/Deploy

- To get started, clone the repo
- Open the project in Xcode
- Turn your iPhone or iPad developer mode *ON*
- Connect your iPhone or iPad to your Mac
- Select your device in Xcode

```Swift
cmd(⌘) + r
```
**Once the app has been loaded onto your device, it will be useable as long as developer mode is on*

## Usage
*After you have OBD-II Buddy loaded onto your iPhone or iPad*

First you will want to ensure that your OBD-II BLE adpater is fully connected to the ODD-II port under your dash. Then start the app by clicking the OBD-II Buddy app icon (see Fig 1).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-App-Icon](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20App%20Icon.png) | ![iPad-App-Icon](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20App%20Icon.png)

*Fig 1. Device Home Screen*

Then you will be prompted to allow OBD-II Buddy Bluetooth access on your device. The app uses Bluetooth to communicate with the vehicle through the OBD-II BLE adapter. Tap "OK" to continue (see Fig 2).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BT_Access](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Bluetooth%20Access.png) | ![iPad-BT-Access](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Bluetooth%20Access.png)

*Fig 2. Bluetooth usage authorizarion*

Next, you will want to scan for your OBD-II BLE adapter. Tap on "Show Available Bluetooth Devices" (see Fig 3).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BT-Scan](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Main%20Menu.png) | ![iPad-BT-Scan](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Main%20Menu.png)

*Fig 3. View available Bluetooth devices*

Once the Peripherals view loads, you will the see available OBD-II BLE adapter(s). In this case iOS-Vlink. Tap on the name of the adapter to connect OBD-II Buddy to your vehicle (see Fig 4).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BLE-Adapter](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Bluetooth%20Device.png) | ![iPad-BLE-Adapter](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Bluetooth%20Device.png)

*Fig 4. Connecting to your vehicle through the BLE adapter*

You will be shown a loading screen once while the app initializes the Bluetooth connection and starts communication with the vehicle (see Fig 5).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BLE-Init](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Initializing%20Bluetooth.png) | ![iPad-BLE-Init](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Initializing%20Bluetooth.png)

*Fig 5. Initializing Bluetooth connection and communication with vehicle*

You are now on the Home screen of OBD-II Buddy. You can choose from one of the available option on the screen. The triple dot symbol at the top of the screen shows the status of your Bluetooth connection. In this case green means connected (see Fig 6).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Connected%20Bluetooth.png) | ![iPad-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Connected%20Bluetooth.png)

*Fig 6. OBD-II Buddy Home Screen*

If you tap "Live Data View" you will be shown the live data for four sensors on your vehicle. Notice the car at the top is now green. While communicating with the vehicle, the app will animate this car symbol and it will be colored green (see Fig 7).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Live-Data](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Live%20Data.png) | ![iPad-Live-Data](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Live%20Data.png)

*Fig 7. OBD-II Buddy Live Data View*

If you would like to change the sensors that are being read, tap on any of the sensor's data locations and you will be shown the options of others sensors that your vehicle supports. To change to a different sensor tap on the desired sensor from the list (see Fig 8).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Sensors](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Sensor%20Select.png) | ![iPad-Sensors](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Sensor%20Select.png)

*Fig 8. OBD-II Buddy sensor customization*

You may leave the Live Data View at anytime, by double tapping on the OBD-II Buddy image in the middle of the view. Note that on iPad there is slightly different functionality. Once the OBD-II Buddy image is double tapped, the Live Data View will disappear, showing optional directions to the user (see Fig 9).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Connected%20Bluetooth.png) | ![iPad-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Home%20Screen.png)

*Fig 9. Closing Live Data View*

If you tap "Trouble Code View" you will be shown a list of any active Diagnostic Trouble Codes (DTCs) that your vehicle is currently storing. You may look these codes up online to help determine what problem your vehicle has. In this case, there are no DTCs and the UI displays that to the user (see Fig 10).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-DTCs](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20No%20Trouble%20Codes.png) | ![iPad-DTCs](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20No%20Trouble%20Codes.png)

*Fig 10. Trouble Code View, no DTCs*

If you tap "Vehicle Info View" you will be shown a list of generic vehicle information. This includes your Vehicle Identification Number (VIN) incase you need it while ordering parts or checking in at dealership (see Fig 11).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Info](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Vehicle%20Info.png) | ![iPad-Info](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Vehicle%20Info.png)

*Fig 11. Vehicle Info View*

To exit the application, use typical Apple app closure. Swipe up from the bottom and dismiss the app. This will disconnect from the BLE adapter and end communication with the vehicle.

## Options
Changing the BLE device information:

Inside BluetoothService.swift, the user can attempt to use an OBD-II BLE device other than the specified iOS-VLink device. To communicate with the device, ensure that you know the devices read/write characteristic UUID and swap it into the if statement. Alternatively, with added print statements the user could find the device and it's characteristics by removing the if statement here and in the next code block.
```Swift
// Function used to discover characteristics of the Bluetooth peripherals in your area
func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    for characteristic in service.characteristics ?? [] {
        // Only allowing the vehicle communication code to be ran for the iOS-Vlink BLE device
        if (String(describing: characteristic.uuid)) == "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F" {
            ...
        }
        ...
    }
    ...
}
```

Inside AvailableDeviceView.swift, the user can remove the if statement to view all nearby Bluetooth devices if they are unsure on the UUID of their OBD-II BLE device. Once found, that information can be swapped into the if statement to only show their BLE device.
```Swift
Form {
    // List of Bluetooth peripherals in your area, remove if to see all devices
    List(bluetoothService.peripherals, id: \.self) { peripheral in
        if peripheral.identifier.description == "715F4D00-B472-1F8B-7ED0-4F10B542017E" 
        || peripheral.identifier.description == "4BCC77F9-32AC-0C74-BB65-365ECF59F447" {
            ...
        }
        ...
    }
    ...
}
```

Editing PIDs:

Inside DataParser.swift, the users can add or remove PIDs. When adding, ensure that you have the correct hex PID, it's data bytes returned, data type returned and description. Next, add the information into each dictionary. Then, ensure that you add the hex PID to myPIDList[].

```Swift

@Published var myPIDList = [String](arrayLiteral: "04", "05", "0A", "0B", "0C", "0D", "0F", "10", "11", "42", "51")

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
```


## Testing

<a href="https://github.com/rbsquires/CSU-Capstone-Project/blob/main/docs/OBD-II%20Test%20Plan.md" target="_blank">View System/User Testing and Results</a>
