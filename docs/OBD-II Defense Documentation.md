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
- Swift and SwiftUI
- CoreBluetooth
- OBD-II protocls


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
- VGate BlueTooth (BLE) Adapter

# Project Requirements

### Software:
- Xcode
- GitHub

### Hardware:
- Mac to Run Xcode and load the selected device
- iPhone running iOS 17.0 or later
- iPad running iOS 17.0 or later
- VGate BlueTooth (BLE) Adapter

### Other:
- Apple Developer Account

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

<a href="https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/pdf/OBD-II%20Buddy%20Test%20Plan.pdf" target="_blank">View test criteria and results</a>

### User Testing:

![UI-Navigation](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Navigation.png)

![UI-Response](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Response.png)

![UI-Spacing-and-Locations](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Spacing%20and%20Locations.png)

![UI-Appearance](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/UI%20Appearance.png)

![Use-OBD-II-Buddy](https://github.com/rbsquires/CSU-Capstone-Project/blob/main/media/images/User%20Testing%20Survey/Use%20OBD-II%20Buddy.png)


# Challenges Overcome

# Future Enhancements
- Save user data to iCloud
- Add PIDs and manufacturer specific PIDs
- Data parsing functionality for other manufacturers
- Refactor code to run on macOS
- Publish application to the App Store

# Presentation Slides
