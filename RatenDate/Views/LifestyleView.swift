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
    @Binding var lookingFor: String?
    @Binding var wantKids: String?
    @Binding var hasKids: String?
    @Binding var politics: String?
    @Binding var religion: String?
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
                    Text("Select Option").tag(String?.none)
                    ForEach(lookingForOptions, id: \.self) {
                        Text($0).tag($0 as String?)
                    }
                }

                Picker("Want Kids?", selection: $wantKids) {
                    Text("Select Option").tag(String?.none)
                    ForEach(yesNoOptions, id: \.self) {
                        Text($0).tag($0 as String?)
                    }
                }

                Picker("Have Kids?", selection: $hasKids) {
                    Text("Select Option").tag(String?.none)
                    ForEach(yesNoOptions, id: \.self) {
                        Text($0).tag($0 as String?)
                    }
                }

                Picker("Politics", selection: $politics) {
                    Text("Select Option").tag(String?.none)
                    ForEach(politicsOptions, id: \.self) {
                        Text($0).tag($0 as String?)
                    }
                }

                Picker("Religion", selection: $religion) {
                    Text("Select Option").tag(String?.none)
                    ForEach(religionOptions, id: \.self) {
                        Text($0).tag($0 as String?)
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
            lookingFor: .constant(nil),
            wantKids: .constant(nil),
            hasKids: .constant(nil),
            politics: .constant(nil),
            religion: .constant(nil),
            onNext: {}
        )
    }
}
