//
//  GenericInfoView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI
import CoreLocation

struct GenericInfoView: View {
    @Binding var name: String
    @StateObject private var locationManager = LocationManager()
    @Binding var occupation: String
    @State private var userInputCity: String = ""  // User-typed city
    @Binding var location: CLLocation  // Bind to the location in the parent view
    var onNext: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Generic Information")) {
                TextField("Name", text: $name)
                
                HStack {
                    // Location TextField
                    TextField("City", text: $userInputCity)
                        .onReceive(locationManager.$placemark) { placemark in
                            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                                userInputCity = "\(city), \(state)"
                            }
                        }
                        .onReceive(locationManager.$location) { newLocation in
                            if let newLocation = newLocation {
                                self.location = newLocation  // Update the bound location with the new value
                            }
                        }
                }
                
                TextField("Occupation", text: $occupation)
            }
            
            Button("Next") {
                onNext()
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

struct GenericInfoView_Previews: PreviewProvider {
    @State static var dummyLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)  // Example coordinates (New York City)
    @State static var dummyName = "John Doe"
    @State static var dummyOccupation = "Software Developer"

    static var previews: some View {
        GenericInfoView(
            name: $dummyName,
            occupation: $dummyOccupation,
            location: $dummyLocation,
            onNext: {}
        )
    }
}
