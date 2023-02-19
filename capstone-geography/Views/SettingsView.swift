//  SettingsView.swift
//  capstone-geography


import SwiftUI

import CoreLocation
import _CoreLocationUI_SwiftUI

struct SettingsView: View {
        
    @EnvironmentObject private var settingsLocationManager: LocationManager
    
    @AppStorage("useImpUnits") var imperialUnits: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("App Settings")) {
                        Toggle("Use Imperial Units", isOn: $imperialUnits)
                    }
                    
                    Section(header: Text("Location"), footer: Text("Location data may not always be accurate.")) {
                        if let coords = settingsLocationManager.location {
                            Text("Coordinates: \(coords.latitude), \(coords.longitude)")
                        }
                        
                        if let address = settingsLocationManager.address {
                            Text("Address:\n\(address)")
                        }
                        
                        Text("Date/Time: \(getDateAndTime(city: "local"))")
                        
                    }
                }
              
            }.navigationTitle("Settings")
            
        }
    }
}
