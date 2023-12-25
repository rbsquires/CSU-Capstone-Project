//
//  OBD_II_BuddyApp.swift
//  OBD-II Buddy
//
//  Created by Bobby Squires on 8/14/23.
//

import SwiftUI

@main
struct OBD_II_BuddyApp: App {
    @StateObject var bluetoothService = BluetoothService()
    
    // Calling specific views for iOS and iPadOS
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadOSContentView()
                    .environmentObject(bluetoothService)
            }
            else {
                iOSContentView()
                    .environmentObject(bluetoothService)
            }
        }
    }
}
