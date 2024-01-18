//
//  LifestyleView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/14/24.
//

//
//  LifestylePreferencesView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/14/24.
//

import SwiftUI

struct LifestyleView: View {
    @Binding var lookingFor: String
    @Binding var wantKids: String
    @Binding var hasKids: String
    @Binding var politics: String
    @Binding var religion: String
    var onNext: () -> Void

    // Sample options for each category
    let lookingForOptions = ["Friendship", "Dating", "Long-term Relationship", "Marriage"]
    let yesNoOptions = ["Yes", "No"]
    let politicsOptions = ["Not Political","Conservative", "Liberal", "Moderate", "Other"]

    let religionOptions = ["Christianity", "Islam", "Atheism", "Hinduism", "Buddhism", "Other"]

    var body: some View {
        Form {
            Section(header: Text("Tell us about yourself")) {
                Picker("Looking For", selection: $lookingFor) {
                    ForEach(lookingForOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Want Kids?", selection: $wantKids) {
                    ForEach(yesNoOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Have Kids?", selection: $hasKids) {
                    ForEach(yesNoOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Politics", selection: $politics) {
                    ForEach(politicsOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                
                Picker("Religion", selection: $religion) {
                    ForEach(religionOptions, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Button("Next") {
                onNext()
            }
        }
    }
}

struct LifestyleView_Previews: PreviewProvider {
    static var previews: some View {
        LifestyleView(
            lookingFor: .constant("Dating"),
            wantKids: .constant("Yes"),
            hasKids: .constant("No"),
            politics: .constant("Liberal"),
            religion: .constant("Christianity"),
            onNext: {}
        )
    }
}
