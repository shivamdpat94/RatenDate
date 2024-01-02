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
    @Binding var location: CLLocation
    @Binding var occupation: String
    var onNext: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Generic Information")) {
                TextField("Name", text: $name)
                Text("Location: (Add location picker)")
                TextField("Occupation", text: $occupation)
            }
            
            Button("Next") {
                onNext()
            }
        }
    }
}

struct GenericInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GenericInfoView(
            name: .constant("John Doe"),
            location: .constant(CLLocation(latitude: 40.7128, longitude: -74.0060)),
            occupation: .constant("Software Developer"),
            onNext: {}
        )
    }
}
