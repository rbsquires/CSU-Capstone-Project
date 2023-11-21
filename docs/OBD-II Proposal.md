# Student Details:
Name: Robert Squires  
Degree/Major: Bachelor of Science in Computer Science  
Project Advisor: Dr. Hayes  
Expected Graduation Date: December 2023

Document #001

# Problem Statement:
The high-priced proprietary vehicle diagnostic/monitoring equipment reveals the need for a cost-effective, fully functional piece of equipment for today’s consumers.

In an ideal world, if an individual wanted to know detailed information about their vehicle’s state, they could just open their phone and see it. Unfortunately, individuals must buy a diagnostic reading tool to perform this task and potentially spend thousands of dollars for high-end proprietary software to see their vehicle's valuable data.

I propose making an open-source application that anyone could use on an Apple iPhone or iPad, that could read their vehicle's data and offer a customizable UI experience. With a tool like that, a user could select the vehicle data that they would like to monitor, set it in their preferred location on the screen and never have to miss out on the ability to monitor their vehicle ever again.

# Project Description:
For my OBD-II reader, I will make an application that allows the user to select 4 vehicle sensor datatypes such as: Engine Rotations Per Minute (RPM), Coolant Temperature, Engine Load Percentage, Battery Voltage, or Throttle Position to monitor. The user will be able to select the desired dataypes they want to monitor and select their position on the screen. The application will allow the user to set the displayed information in whatever priority they would like and save that user customized setup.

If I am able to get the application to fully function for the above requirements, I will try to implement the ability to read and clear diagnostic codes, as well as the ability to display vehicle information such as VIN and Calibration ID.

# Proposed Language(s):
I will write the application in Swift and SwiftUI.

# Libraries/Packages/Development Kits:
I will use Xcode for the entire development process of the application, to include: SwiftUI, CoreBluetooth, and Foundation frameworks.

# Additional Software/Equipment Needed:
I will need to use Xcode on my MacBook (Ventura 13.6) for development, and deploy the applicaton on iPhone (iOS 16) and iPad (iPadOS 16). I will also need an ELM 327 OBD-II Bluetooth Low Energy adapter. ![Vgate-iCar-Pro-Bluetooth-4.0-(BLE)] (https://www.amazon.com/gp/product/B06XGB4873/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&th=1)

# Outline of Future Research Efforts:
I will have to learn to code in Swift/SwiftUI, which will include learning syntax from the ground up, and more advanced concepts for data retrieval, manipulation, and output for the GUI.

I will also need to learn how to use the CoreBluetooth framework to properly establish a Bluetooth connection between the Apple device and the BLE OBD-II adapter. The use of CoreBluetooth will ensure the ability to request and retrieve data from the vehicle (2014 Toyota Tacoma) to include: PIDs, DTCs and other vehicle information.


# Schedule:
The following schedule will be used to keep pace and ensure that my project is completed on time:  
1. June 1, 2023  
    - Study Swift and SwiftUI to learn how to use the language to write my application.

2. July 1, 2023  
    - Continue Swift and SwiftUI, and CoreBluetooth for application development.
    - Purchase OBD-II adapter required to connect to the vehicle and gain data access from the ECU.

3. August 1, 2023  
    - Have initial application capable of reading vehicle data and begin to code the GUI.

4. September 1, 2023  
    - Ensure that the GUI is fully functional.
    - Have a minimum viable product (MVP) ready for phase 2 of Capstone Project.
    - Create a plan for application unit and usability testing
    - Begin testing of the entire application and fix any bugs that are found.

5. October 1, 2023  
    - Continue application unit and usability testing and bug fixes.
    - Create a system test plan for the application.
    - Have fully functional application ready for phase 3 of Capstone Project.

6. November 1, 2023 
    - Begin system testing of entire application.
    - Continue system testing and applicaton refinement.
    - Complete system testing and have polished project application.

7. November 14, 2023  
    - Prepare for the presentation and defense of my application.

8. November 20, 2023  
    - Conduct User Testing for application.
    - Final application complete and presentation/defense before the board.
    
