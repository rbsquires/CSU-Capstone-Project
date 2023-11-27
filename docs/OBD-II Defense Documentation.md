# Student Details
Name: Robert Squires  
Degree/Major: Bachelor of Science in Computer Science  
Project Advisor: Dr. Hayes  
Expected Graduation Date: December 2023

Document #004

# Problem Statement
The high-priced proprietary vehicle diagnostic/monitoring equipment reveals the need for a cost-effective, fully functional piece of equipment for today’s consumers.

In an ideal world, if an individual wanted to know detailed information about their vehicle’s state, they could just open their phone and see it. Unfortunately, individuals must buy a diagnostic reading tool to perform this task and potentially spend thousands of dollars for high-end proprietary software to see their vehicle's valuable data.

I propose making an open-source application that anyone could use on an Apple iPhone or iPad, that could read their vehicle's data and offer a customizable UI experience. With a tool like that, a user could select the vehicle data that they would like to monitor, set it in their preferred location on the screen and never have to miss out on the ability to monitor their vehicle ever again.

# Research and Background
### Swift and SwiftUI:
To develop this OBD-II application I had to learn to code in *Swift*, and use *SwiftUI* for the UI. This took some time but once I understood the basics of the language I was able to start implementing my application. *Apple* provides great documentation for both <a href="https://developer.apple.com/documentation/swift" target="_blank">*Swift*</a> and <a href="https://developer.apple.com/documentation/SwiftUI" target="_blank">*SwiftUI*</a>. As I continued to develop the application I would have to learn new aspects of *Swift* or *SwiftUI* to accomplish the task I was working on. For instance, establishing the *Bluetooth* connection to the OBD-II BLE device. For *Apple* devices, this requires the use of the <a href="https://developer.apple.com/documentation/corebluetooth" target="_blank">*Core Bluetooth*</a> framework. Understanding the use of the *Core Bluetooth* Managers and Delegates as well as the Peripherals and Characteristics was important and took some time to implement properly. Below are some helpful links to resources outside of *Apple* that aided me in using *Core Bluetooth*:

- <a href="https://novelbits.io/intro-ble-mobile-development-ios/" target="_blank">*The Ultimate Guide to Apple’s Core Bluetooth*</a> 
- <a href="https://developer.apple.com/documentation/corebluetooth" target="_blank">*Introduction to BLE Mobile Development iOS Part 1*</a> and <a href="https://novelbits.io/intro-ble-mobile-development-ios-part-2/" target="_blank">*Part 2*</a>

After achieving successful *Bluetooth* pairing and building the ability to send/receive data to/from the vehicle, I continued on to developing the UI with *SwiftUI*. The majority of this was trial and error, but when I would get stuck I would have to consult *Apple's documentation* or look for help from one of the *YouTube Swift* educators listed below:

- <a href="https://www.youtube.com/@twostraws" target="_blank">Paul Hudson</a> 
- <a href="https://www.youtube.com/@seanallen" target="_blank">Sean Allen</a>
- <a href="https://www.youtube.com/@SwiftfulThinking" target="_blank">*Swiftful Thinking*</a>

### OBD-II Protocols:
The On-Board Diagnostics-II <a href="https://www.csselectronics.com/pages/obd2-explained-simple-intro" target="_blank">(OBD-II)</a> protocols are essential to communicating with a vehicle. The main OBD-II protocols that are used with the Controller Area Network (CAN) Bus in modern vehicles include: SAE J1850 PWM, SAE J1850 VPW, ISO9141-2, ISO14230-4 (KWP2000), and ISO 15765-4/SAE J2480. These protocls are standards that dictate how the vehicle communicates through the OBD-II port over the CAN. I had to do some research and figured out that my 2014 *Toyota Tacoma* uses the ISO 15765-4 (11bit/500kbaud) protocol. Knowing the protocol used by the vehicle is paramount, because it determines how you request/receive data, both the size and speed of each transmission. Another aspect of communicating with the vehicle through the OBD-II port, are Parameter IDs (PIDs). There are both generic and proprietary PIDs that vehicle manufacturers use. The generic PIDs easy to find but many of the proprietary from manufacturers are not available to the public. Some helpful links for understanding OBD-II protocols and generic PIDs are listed below:

- <a href="https://www.csselectronics.com/pages/obd2-explained-simple-intro" target="_blank">*OBD2 Explained - A Simple Intro [2023]*</a>
- <a href="https://en.wikipedia.org/wiki/OBD-II_PIDs" target="_blank">OBD-II PIDs</a>

### ELM 327 BLE:
Bridging the gap between the user's device and the vehicle's OBD-II port is the ELM 327 microcontroller, developed by *ELM Electronics*. This microcontroller is built into most OBD-II BLE devices and is used to pass data between the application and the vehicle. The ELM 327 allows the user to send AT commands to configure the BLE device, as well as communicate with the vehicle's Engine Control Unit (ECU). The microcontroller also allows for protocol specific commands and a wide range of setting adjustments to suit the user's needs. Below is a detailed breakdown of ELM 327 microcontrollers from the manufacturer:

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
    - a link to the source code repository

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

# Future Enhancements
- Save user data to iCloud
- Add PIDs and manufacturer specific PIDs
- Data parsing functionality for other manufacturers
- Refactor code to run on macOS
- Publish application to the App Store

# Presentation Slides
