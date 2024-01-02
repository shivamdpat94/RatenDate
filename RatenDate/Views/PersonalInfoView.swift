//
//  PersonalInfoView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI

struct PersonalInfoView: View {
    @Binding var bio: String
    @Binding var interests: String
    @Binding var lookingFor: String
    var onComplete: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("About You")) {
                TextField("Bio", text: $bio)
                TextField("Interests (comma-separated)", text: $interests)
                TextField("Looking For", text: $lookingFor)
            }
            
            Button("Complete Sign Up") {
                print("Complete Sign UP")
                onComplete()
            }
        }
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView(
            bio: .constant("I love outdoor activities and photography."),
            interests: .constant("Hiking, Photography, Cooking"),
            lookingFor: .constant("A serious relationship"),
            onComplete: {}
        )
    }
}
