# capstone-geography
This is the front-end portion of the Swift Geography mobile application project. The repository for the API (back-end) can be found [here](https://github.com/EZIC13/capstone-api).

<br/>

# Front-end Details
The front-end of this project was built in Xcode and is written in SwiftUI. It is currently compatible with iOS and iPadOS devices. The application pulls the data from the back-end API and displays it in a list to the user. The user can then navigate the list by scrolling through it or by using the searchbar. Any country from the list can be selected and the user will be directed to a details screen. This will include a map of the capital and basic geographic/demographic information. A settings screen is also present which allows the user to toggle imperial/metric units and also view their location information.

# MapView.swift
This file contains a SwiftUI view that takes in a `CLLocationCoordinate2D` as a parameter (referred to as `coordinate`) and returns a map of the coordinates provided. It contains a `setRegion(_ coordinate: CLLocationCoordinate2D)` function that converts the `coordinate` into a `MKCoordinateRegion` and updates the `region` state that the map is bound to.

<br/>

# LocationManager.swift
This file contains the `LocationManager` class that deals with tracking the devices location. It does this by conforming to the `ObservableObject` protocol and contains the following variables to be updated:
```swift
@Published var location: CLLocationCoordinate2D?
@Published var address: String?
@Published var distance: Int?
```
Once the devices location is first established (and whenever it changes), `location` is updated with the coordinates, and `address` is updated with the reverse geolocated location of the same coordinates.

The `getDistance(from: CLLocation)` method is called whenever the user selects a new `CountryDetail` page. The `distance` is calculated to be the distance in meters from the devices location and the countries captital city coordinates returned from the API.

<br/>

# Data.swift
This file contains the following:
- The `Country` struct that contains the schema for each countries information
- The `CountriesService` class that gets the country information to the user. 
- The `getDateAndTime` function that takes in a city as a parameter and returns the local date and time. 

The `Country` struct is the schema for how the `CountriesService` class publishes data: <INSERT_STRUCT>

The `CountriesService` class conforms to the `ObservableObject` protocol and has the following variable to be updated: 
```swift
@Published var countries: [Country]: []
```
The `getCountries()` method pulls data from the API and updates the `countries` var for the data to be displayed. Once the data is pulled, it will be saved locally to the device for offline viewing. If the API cannot be pulled (for example, it is down or the device is not connected to the internet), this method will pull the locally stored data and use it accordingly.

The `getDateAndTime(city: String) -> String` function takes in a city name as a string and returns another string that contains the date the time of the `city` paramater. The data is returned in 24 hour time and is formatted as follows: `MM/dd/yyyy HH:mm:ss`.

<br/>

# SearchBar.swift
This file contains the `SearchBar` view that allows the user to filter the list of all countries. When text is entered into the searchbar, the `text` var will be updated to the current contents of the searchbar. This value will then be used to filter the list of countries to only those containing the `search` string. The text inside the searchbar can be cleared, and a cancel button is also present. 

<br/>

# CountryDetail.swift
This file contains the view that shows all of the details about a given country. Each instance takes in a `Country` parameter and shows the following information: 
- A `MapView` instance showing the capital city on the map
- The country's name
- The country's flag
- A list containing the following sections: 
  - Dynamic Info (lists the local date/time and distance from the user)
  - Geographic Info (lists the capital city, subregion, area, and whether the country is landlocked)
  - Demographic Info (lists the country's population and demonym)

<br/>

# CountryList.swift
This file contains the view that the user sees when the first open the app. It contains a `SearchBar` instance that filters the list to only show countries containing the text in the bar. If it is empty, all countries are shown. The list is sorted alphabetically and each letter section is collapsable. Each list item contains the country's name and flag, and pressing on it will redirect the user to a `CountryDetail` instance that displays information on that specific country. The toolbar contains a button to bring up the `SettingsView` sheet.

<br/>

# SettingsView.swift
This file contains the view that appears when they press on the gear icon in the `CountryList` screen. It contains the following:
- A toggle to display imperial or metric units throughout the app (this boolean is saved to UserDefaults)
- The coordinates of the user's current location
- A reverse geocoded address from the above coordinates
- The date and time of the user's current location
