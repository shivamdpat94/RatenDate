//
//  DemographicInfoView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI

struct DemographicInfoView: View {
    @Binding var age: Int
    @Binding var gender: String
    @Binding var ethnicity: String
    @Binding var height: String
    var onNext: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Demographic Information")) {
                Stepper("Age: \(age)", value: $age, in: 18...100)
                TextField("Gender", text: $gender)
                TextField("Ethnicity", text: $ethnicity)
                TextField("Height", text: $height)
            }
            
            Button("Next") {
                onNext()
            }
        }
    }
}

struct DemographicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DemographicInfoView(
            age: .constant(28),
            gender: .constant("Male"),
            ethnicity: .constant("Hispanic"),
            height: .constant("5'9\""),
            onNext: {}
        )
    }
}
