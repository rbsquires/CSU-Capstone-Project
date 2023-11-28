# Student Details
Name: Robert Squires  
Degree/Major: Bachelor of Science in Computer Science  
Project Advisor: Dr. Hayes  
Expected Graduation Date: December 2023

Document #004

# Problem Statement
&emsp;&emsp;The high-priced proprietary vehicle diagnostic/monitoring equipment reveals the need for a cost-effective, fully functional piece of equipment for today’s consumers.

In an ideal world, if an individual wanted to know detailed information about their vehicle’s state, they could just open their phone and see it. Unfortunately, individuals must buy a diagnostic reading tool to perform this task and potentially spend thousands of dollars for high-end proprietary software to see their vehicle's valuable data.

I propose making an open-source application that anyone could use on an Apple iPhone or iPad, that could read their vehicle's data and offer a customizable UI experience. With a tool like that, a user could select the vehicle data that they would like to monitor, set it in their preferred location on the screen and never have to miss out on the ability to monitor their vehicle ever again.

# Research and Background
### Swift and SwiftUI:
&emsp;&emsp;To develop this OBD-II application I had to learn to code in <a href="https://www.swift.org/documentation/" target="_blank">*Swift*</a>, and use *SwiftUI* for the UI. This took some time but once I understood the basics of the language I was able to start implementing my application. *Apple* provides great documentation for both <a href="https://developer.apple.com/documentation/swift" target="_blank">*Swift*</a> and <a href="https://developer.apple.com/documentation/SwiftUI" target="_blank">*SwiftUI*</a>. As I continued to develop the application I would have to learn new aspects of *Swift* or *SwiftUI* to accomplish the task I was working on. For instance, establishing the *Bluetooth* connection to the OBD-II BLE device. For *Apple* devices, this requires the use of the <a href="https://developer.apple.com/documentation/corebluetooth" target="_blank">*Core Bluetooth*</a> framework. Understanding the use of the *Core Bluetooth* Managers and Delegates as well as the Peripherals and Characteristics was important and took some time to implement properly. Below are some helpful links to resources outside of *Apple* that aided me in using *Core Bluetooth*:

- <a href="https://novelbits.io/intro-ble-mobile-development-ios/" target="_blank">*The Ultimate Guide to Apple’s Core Bluetooth*</a> 
- <a href="https://developer.apple.com/documentation/corebluetooth" target="_blank">*Introduction to BLE Mobile Development iOS Part 1*</a> and <a href="https://novelbits.io/intro-ble-mobile-development-ios-part-2/" target="_blank">*Part 2*</a>

After achieving successful *Bluetooth* pairing and building the ability to send/receive data to/from the vehicle, I continued on to developing the UI with *SwiftUI*. The majority of this was trial and error, but when I would get stuck I would have to consult *Apple's documentation* or look for help from one of the *YouTube Swift* educators listed below:

- <a href="https://www.youtube.com/@twostraws" target="_blank">Paul Hudson</a> 
- <a href="https://www.youtube.com/@seanallen" target="_blank">Sean Allen</a>
- <a href="https://www.youtube.com/@SwiftfulThinking" target="_blank">*Swiftful Thinking*</a>

### OBD-II Protocols:
&emsp;&emsp;The On-Board Diagnostics-II <a href="https://www.csselectronics.com/pages/obd2-explained-simple-intro" target="_blank">(OBD-II)</a> protocols are essential to communicating with a vehicle. The main OBD-II protocols that are used with the Controller Area Network (CAN) Bus in modern vehicles include: SAE J1850 PWM, SAE J1850 VPW, ISO9141-2, ISO14230-4 (KWP2000), and ISO 15765-4/SAE J2480. These protocls are standards that dictate how the vehicle communicates through the OBD-II port over the CAN. I had to do some research and figured out that my 2014 *Toyota Tacoma* uses the ISO 15765-4 (11bit/500kbaud) protocol. Knowing the protocol used by the vehicle is paramount, because it determines how you request/receive data, both the size and speed of each transmission. Another aspect of communicating with the vehicle through the OBD-II port, are Parameter IDs (PIDs). There are both generic and proprietary PIDs that vehicle manufacturers use. The generic PIDs easy to find but many of the proprietary from manufacturers are not available to the public. Some helpful links for understanding OBD-II protocols and generic PIDs are listed below:

- <a href="https://www.csselectronics.com/pages/obd2-explained-simple-intro" target="_blank">*OBD2 Explained - A Simple Intro [2023]*</a>
- <a href="https://en.wikipedia.org/wiki/OBD-II_PIDs" target="_blank">OBD-II PIDs</a>

### ELM 327 BLE:
&emsp;&emsp;Bridging the gap between the user's device and the vehicle's OBD-II port is the ELM 327 microcontroller, developed by *ELM Electronics*. This microcontroller is built into most OBD-II BLE devices and is used to pass data between the application and the vehicle. The ELM 327 allows the user to send AT commands to configure the BLE device, as well as communicate with the vehicle's Engine Control Unit (ECU). The microcontroller also allows for protocol specific commands and a wide range of setting adjustments to suit the user's needs. Below is a detailed breakdown of ELM 327 microcontrollers from the manufacturer:

- <a href="https://www.elmelectronics.com/DSheets/ELM327DSH.pdf" target="_blank">*ELM 327 OBD to RS232 Interpreter*</a>

# Project Language(s), Software, and Hardware

### Languages:
- Swift
- SwiftUI

### Software:
- Xcode
- Git
- GitHub
- VSCode
  
### Hardware:
- iPhone Pro 14
- iPad Pro 12"
- MacBook Pro 14"
- <a href="https://www.amazon.com/gp/product/B06XGB4873/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&th=1" target="_blank">Vgate iCar Pro Bluetooth 4.0 (BLE)</a>

# Project Requirements

### Software:
- Xcode 15 (<a href="https://developer.apple.com/xcode/" target="_blank">Download</a> or use the *App Store*)
- GitHub Account (<a href="https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home" target="_blank">Sign Up</a>)

### Hardware:
- Mac to Run Xcode and load the selected device
- iPhone **running iOS 17.0 or later*
- iPad **running iPadOS 17.0 or later*
- Vgate iCar Pro Bluetooth 4.0 (BLE)

### Other:
- Apple Developer Account (<a href="https://developer.apple.com" target="_blank">Sign Up</a>)

<a href="https://github.com/rbsquires/CSU-Capstone-Project/blob/main/docs/OBD-II%20Requirements.md" target="_blank">View Requirements Documentation</a>


# Project Implementation
  - This section details the design and features of the in paragraph form with references to the following:
    - screenshots with numbered captions (e.g., Fig 1. The loading screen.)
### Description:

&emsp;&emsp;OBD-II Buddy was built as a personal alternative to OBD-II *Bluetooth* apps such as *Carly*, *FIXD*, and *OBD Fusion*. It is built to be lightweight, responsive and easy to use. The user can open the app and check live data for sensors such as: Coolant Temperature, Intake Air Temperature, Engine Speed, Vehicle Speed, MAF rate, Engine Laod, Battery Voltage and Throttle Position. They can also scan for any Diagnostic Trouble Codes (DTCs), clear DTCs, and view generic vehicle data such as their Vehicle Identification Number (VIN). The application is scalable and customizable for each user's unique needs.

### Design:
The user needs to  ensure that their OBD-II BLE device is fully connected to the ODD-II port under the dash. The user can then turn their vehicle's key to the on position or start the vehicle. Then start the app by tapping the OBD-II Buddy app icon (see Fig 1).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-App-Icon](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20App%20Icon.png) | ![iPad-App-Icon](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20App%20Icon.png)

*Fig 1. Device Home Screen*

The uer is prompted to allow OBD-II Buddy Bluetooth access on their device. The app uses Bluetooth to communicate with the vehicle through the OBD-II BLE adapter. Tap "OK" to continue (see Fig 2).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BT_Access](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Bluetooth%20Access.png) | ![iPad-BT-Access](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Bluetooth%20Access.png)

*Fig 2. Bluetooth usage authorizarion*

Next, the user can scan for their OBD-II BLE adapter by tapping on "Show Available Bluetooth Devices" (see Fig 3).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BT-Scan](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Main%20Menu.png) | ![iPad-BT-Scan](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Main%20Menu.png)

*Fig 3. View available Bluetooth devices*

On the Peripherals view, the user will the see available OBD-II BLE adapter(s). In this case iOS-Vlink. Tap on the name of the adapter to connect OBD-II Buddy to your vehicle (see Fig 4).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BLE-Adapter](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Bluetooth%20Device.png) | ![iPad-BLE-Adapter](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Bluetooth%20Device.png)

*Fig 4. Connecting to your vehicle through the BLE adapter*

The user will be shown a loading screen while the app initializes the Bluetooth connection and starts communication with the vehicle (see Fig 5).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-BLE-Init](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Initializing%20Bluetooth.png) | ![iPad-BLE-Init](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Initializing%20Bluetooth.png)

*Fig 5. Initializing Bluetooth connection and communication with vehicle*

The user will now be shown the Home Screen of OBD-II Buddy. The user can tap one of the available option on the screen. The triple dot symbol at the top of the screen shows the status of your *Bluetooth* connection. In this case green means *Bluetooth* is connected (see Fig 6).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Connected%20Bluetooth.png) | ![iPad-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Connected%20Bluetooth.png)

*Fig 6. OBD-II Buddy Home Screen*

If the user tapped the "Live Data View" they will be shown the live data for four sensors on their vehicle. Notice the car at the top is now green. While communicating with the vehicle, the app will animate this car symbol and it will be colored green (see Fig 7).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Live-Data](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Live%20Data.png) | ![iPad-Live-Data](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Live%20Data.png)

*Fig 7. OBD-II Buddy Live Data View*

The user can change the sensors that are being read by tapping on any of the sensor's data locations and they will be shown the other sensors that their vehicle supports. To change to a different sensor tap on the desired sensor from the list (see Fig 8). The current sensor for that positon on the screen has a green check mark, while the other sensors are marked "In Use" and are disabled from selection.
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Sensors](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Sensor%20Select.png) | ![iPad-Sensors](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Sensor%20Select.png)

*Fig 8. OBD-II Buddy sensor customization*

The user may leave the Live Data View at anytime, by double tapping on the OBD-II Buddy image in the middle of the view. Note that on iPad there is slightly different functionality. Once the OBD-II Buddy image is double tapped, the Live Data View will disappear, showing optional directions to the user (see Fig 9).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Main%20Menu.png) | ![iPad-Homescreen](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Home%20Screen.png)

*Fig 9. Closing Live Data View*

If the user tapped "Trouble Code View" they will be shown a list of any active DTCs that their vehicle is currently storing. The user can look these codes up online to help determine what problem their vehicle has. In this case, there are no DTCs and the UI displays that to the user (see Fig 10).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-DTCs](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20No%20Trouble%20Codes.png) | ![iPad-DTCs](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20No%20Trouble%20Codes.png)

*Fig 10. Trouble Code View, no DTCs*

If the user tapped "Vehicle Info View" they will be shown a list of generic vehicle information. This includes their VIN, Calibration ID, OBD-II Protocol, ECU Name, and Fuel Type (see Fig 11).
iPhone | iPad
:-------------------------:|:-------------------------:
![iPhone-Info](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPhone/iPhone%20Vehicle%20Info.png) | ![iPad-Info](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/OBD-II%20Buddy%20Pictures/iPad/iPad%20Vehicle%20Info.png)

*Fig 11. Vehicle Info View*

To exit the application, use typical Apple app closure. Swipe up from the bottom and dismiss the app. This will disconnect from the BLE adapter and end communication with the vehicle.


[View Source Code Repo](https://github.com/rbsquires/CSU-Capstone-Project/tree/main/OBD-II%20Buddy/OBD-II%20Buddy)

# Test Plan

### System Testing:
The following system testing will be conducted on both iPhone 14 Pro and iPad Pro
- Check App Launch
- Check Bluetooth scanning
- Select and Pair with Bluetooth device
- Loading screen works
- App Home View
- Functionality of 
"Vehicle Info View" button
- "Back" button functionality in Vehicle Info View
- Functionality of 
"Trouble Code View" button
- "Back" button functionality in Trouble Code View
- Functionality of the
"Live Data View" button
- Current sensor data
request and response
- Sensor 1 customization 
(Selection)
- Sensor 1 customization 
(No Selection)
- Sensor 2 customization 
(Selection)
- Sensor 2 customization 
(No Selection)
- Sensor 3 customization 
(Selection)
- Sensor 3 customization 
(No Selection)
- Sensor 4 customization 
(Selection)
- Sensor 4 customization 
(No Selection)
- "Back" button functionality in Live Data View
- App disconnect/termination **debugger mode*
- App termination

### User Testing:
The following system testing will be conducted on both iPhone 14 Pro and iPad Pro
- Check App Launch
- Check Bluetooth scanning
- Select and Pair with Bluetooth device
- Loading screen works
- App Home View
- Functionality of 
"Vehicle Info View" button
- "Back" button functionality in Vehicle Info View
- Functionality of 
"Trouble Code View" button
- "Back" button functionality in Trouble Code View
- Functionality of the
"Live Data View" button
- Current sensor data
request and response
- Sensor 1 customization 
(Selection)
- Sensor 1 customization 
(No Selection)
- Sensor 2 customization 
(Selection)
- Sensor 2 customization 
(No Selection)
- Sensor 3 customization 
(Selection)
- Sensor 3 customization 
(No Selection)
- Sensor 4 customization 
(Selection)
- Sensor 4 customization 
(No Selection)
- "Back" button functionality in Live Data View
- App disconnect/termination **debugger mode*
- App termination

# Test Results

### System Testing:

<a href="https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/pdf/OBD-II%20Buddy%20Test%20Plan.pdf" target="_blank">View Test Criteria and Results</a>

### User Testing:

![UI-Navigation](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Navigation.png)

![UI-Response](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Response.png)

![UI-Spacing-and-Locations](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Spacing%20and%20Locations.png)

![UI-Appearance](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Appearance.png)

![Use-OBD-II-Buddy](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/Use%20OBD-II%20Buddy.png)

<a href="https://github.com/rbsquires/CSU-Capstone-Project/blob/main/docs/OBD-II%20Test%20Plan.md" target="_blank">View Test Plan Documentation</a>

# Challenges Overcome

### Learning *Swift/SwiftUI*:
Although I enjoyed learning to program in *Swift* and *SwiftUI*, it was a challenge. Most of my experience to date had been in *C++* and *Java*. So I had to learn common programming tasks such as iteration, function calls and passing parameters by reference in *Swift*. I also had to learn *SwiftUI* for my UI development, developing skills in view management, transitions and passing data between views.

### Establishing a *Bluetooth* connection with *Core Bluetooth*:
Establishing the *Bluetooth* connection using the *Core Bluetooth* framework was one of the largest challenges I overcame during the implementation of this project. Trying to understand how to setup a *Core Bluetooth* connection with my adapter, using the Managers and Delegates, as well as the Peripherals and their Characteristics took some time. This paired with trying to customize functionality for my application into the framework's functionality was challenging. This challenge was extremely rewarding once I broke through and implemented the functionality I wanted in my application.

### Timeframe:
I spent a lot of time thinking of the project I wanted to develop. Unfortunately, life happens and pairing that with the decision to change my application to be for *Apple* devices I limited myself on time. I was able to redo my documentation and complete the full development cycle in under 6 months.

# Future Enhancements
- Save user data to iCloud
- Add PIDs and manufacturer specific PIDs
- Data parsing functionality for other manufacturers
- Refactor code to run on macOS
- Publish application to the App Store

# Presentation Slides
