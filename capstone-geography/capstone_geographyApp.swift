//  capstone_geographyApp.swift
//  capstone-geography

import SwiftUI

@main
struct capstone_geographyApp: App {
    
    //This instance can be used globally be wrapping a var as an @EnvironmentObject
    @ObservedObject var globalLocationManager: LocationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalLocationManager)
        }
    }
}
