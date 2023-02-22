//  Data.swift
//  capstone-geography


import Foundation
import SwiftUI
import CoreLocation


//Country Struct
struct Country: Hashable, Codable, Identifiable {
    var id: Int
    var name_common: String
    var name_official: String
    var flag: String
    var region: String
    var subregion: String
    var capital: String
    var landlocked: Bool
    var area: Int
    var population: Int
    var demonym: String
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }

    private var coordinates: Coordinates

    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
}

//Country fetching class
class CountriesService: ObservableObject {

    @Published var countries: [Country] = []
    
    init() {
        getCountries()
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Could not find \(filename) in main bundle")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Could not load \(filename) from main bundle: \(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Could not parse \(filename) as \(T.self): \(error)")
        }
    }

    func getCountries() {
        let url = URL(string: "http://ec2-44-232-173-177.us-west-2.compute.amazonaws.com:3000/countries")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //If cannot get data from server
            if let error = error {
                print("Error retrieving countries from server: \(error.localizedDescription)")
                
                //Retreive from local storage
                if let savedCountries = UserDefaults.standard.object(forKey: "countries") as? Data {
                    let decoder = JSONDecoder()
                    do {
                        let countries = try decoder.decode([Country].self, from: savedCountries)
                        //Update in main thread
                        DispatchQueue.main.async {
                            self.countries = countries
                            print("Retrieved saved countries from UserDefaults")
                        }
                    } catch {
                        print("Error decoding saved countries: \(error)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.countries = self.load("countries.json")
                        print("Retrieved saved countries from JSON")
                    }
                }
                return
            }

            //If got data from server
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let countries = try decoder.decode([Country].self, from: data)
                    //Update in main thread
                    DispatchQueue.main.async {
                        self.countries = countries
                        print("Got countries from server")
                        
                        //Save to local storage for offline viewing
                        let encoder = JSONEncoder()
                        do {
                            let encodedCountries = try encoder.encode(countries)
                            UserDefaults.standard.set(encodedCountries, forKey: "countries")
                            print("Saved countries to UserDefaults")
                        } catch {
                            print("Error encoding countries: \(error)")
                        }
                    }
                } catch {
                    print("Error decoding countries: \(error)")
                }
            }
        }.resume()
    }
}



//Time
func getDateAndTime(city: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
    
    //Device location time
    if city == "local" {
        dateFormatter.timeZone = TimeZone(identifier: String(TimeZone.autoupdatingCurrent.identifier))
        return dateFormatter.string(from: Date())
    } else {
        //City parameter passed in
        let timeZone = TimeZone.knownTimeZoneIdentifiers.first {
            $0.localizedStandardContains(city)
        }
        guard let cityTimeZone = timeZone else {
            return "ERROR"
        }
        dateFormatter.timeZone = TimeZone(identifier: cityTimeZone)
        return "Date/Time: \(dateFormatter.string(from: Date()))"
    }

}
