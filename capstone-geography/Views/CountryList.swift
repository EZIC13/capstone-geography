//  CountryList.swift
//  capstone-geography

import SwiftUI

// This struct defines the CountryList view
struct CountryList: View {
    
    @ObservedObject var countriesService = CountriesService()
    
    //Whether the app should show the setttings sheet
    @State private var showingSettings: Bool = false
    
    //Text in searchbar
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                //The searchbar
                SearchBar(text: $searchText)
                
                Text("Data retrieved from \(countriesService.source)")
                
                //Search results (shows all countries if its empty)
                List {
                    // Iterates through a sorted array of unique first letters of the country names
                    ForEach(Array(Set(countriesService.countries.filter {
                        // Filters the list of countries to only include those whose name contains the search text
                        self.searchText.isEmpty ? true : $0.name_common.lowercased().contains(self.searchText.lowercased())
                    }.map({ String($0.name_common.first!).uppercased() })
                    )).sorted(), id: \.self) { letter in
                        //Make a section for each letter
                        Section(header: Text(letter)) {
                            //Only show countries containing the search text
                            ForEach(countriesService.countries.filter {
                                self.searchText.isEmpty ? true : $0.name_common.lowercased().contains(self.searchText.lowercased())
                            }.filter({
                                //Only show countries satrting with the current letter
                                String($0.name_common.first!).uppercased() == letter
                            }), id: \.id) { country in
                                //Routes to the details page for any specific country
                                NavigationLink(destination: CountryDetail(country: country)) {
                                    //Label for the nav link
                                    HStack {
                                        AsyncImage(url: URL(string: country.flag)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 65, height: 40)
                                        
                                        Spacer()
                                            .frame(width: 20)
                                        
                                        Text(country.name_common)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("All Countries")
                //Settings sheet functionality
                .toolbar {
                    Button {
                        showingSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
            }
        }
    }
}
