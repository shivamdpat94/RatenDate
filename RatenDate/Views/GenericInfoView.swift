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
                    
                    // Location Button
                    Button(action: {
                        locationManager.requestPermission()
                        locationManager.getLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
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
    static var previews: some View {
        GenericInfoView(
            name: .constant("John Doe"),
            occupation: .constant("Software Developer"),
            onNext: {}
        )
    }
}
