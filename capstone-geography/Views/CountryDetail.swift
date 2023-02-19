//  CountryDetail.swift
//  capstone-geography


import SwiftUI

import CoreLocation
import _CoreLocationUI_SwiftUI


struct CountryDetail: View {
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var country: Country
    
    @EnvironmentObject private var detailsLocationManager: LocationManager
    
    @AppStorage("useImpUnits") var imperialUnits: Bool = false

    
    var body: some View {

        ScrollView {
            
            MapView(coordinate: country.locationCoordinates)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            
            
            VStack(alignment: .leading) {
                
                //Title group
                Group {
                    HStack {
                        Text(country.name_common)
                            .font(.title)
                                                
                        Spacer()

                        AsyncImage(url: URL(string: country.flag)) {image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 65, height: 40)
                        
                    }
                    
                    Divider()
                }
                
                Spacer()
                    .frame(height: 15)
                
                
                //Info list
                List {
                    
                    Section(header: Text("Dynamic Info")) {
                        
                        if getDateAndTime(city: country.capital) != "ERROR" {
                            Text(getDateAndTime(city: country.capital))
                        }
                                                
                        VStack {
                            if let distance = detailsLocationManager.distance {
                                imperialUnits ? Text("Distance from your location: \(Int((Double(distance) / 1609.34).rounded())) miles") : Text("Distance from your location: \(distance / 1000) kilometers")
                            }
                        }
                        .onAppear {
                            detailsLocationManager.getDistance(from: CLLocation(latitude: country.locationCoordinates.latitude, longitude: country.locationCoordinates.longitude))
                        }
                    }
                    
                    Section(header: Text("Geographic Info")) {
                        Text("Capital City: \(country.capital)")

                        Text("Subregion: \(country.subregion)")
                        
                        imperialUnits ? Text("Area: \(Int(Double(country.area) / 2.59)) mi\u{00B2}") : Text("Area: \(Int(country.area)) km\u{00B2}")
                        
                        country.landlocked ? Text("Landlocked") : Text("Not Landlocked")
                    }
                    
                    Section(header: Text("Demographic Info")) {
                        Text("Population: \(country.population)")

                        Text("Demonym: \(country.demonym)")
                    }
                    
                }.frame(minHeight: minRowHeight * 12.5) //change this value to make the list more/less scrollable
            
            }
            .padding()
        }
        .navigationTitle(country.name_common)
        .navigationBarTitleDisplayMode(.inline)

    }
}
