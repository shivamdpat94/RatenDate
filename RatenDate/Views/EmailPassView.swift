import SwiftUI
import Firebase

struct EmailPassView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var phoneNumber: String

    @State private var formattedPhoneNumber: String = ""
    
    var onNext: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Your Credentials")) {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                TextField("Cell Phone", text: $formattedPhoneNumber)
                    .keyboardType(.numberPad)
                    .onReceive(formattedPhoneNumber.publisher.collect()) {
                        let digits = String($0).filter { "0"..."9" ~= $0 }
                        if digits != phoneNumber {
                            phoneNumber = digits
                            formattedPhoneNumber = format(phoneNumber: digits)
                        }
                    }
            }
            
            Button("Next") {
                onNext()
            }
        }
    }

    private func format(phoneNumber: String) -> String {
        let zip = phoneNumber.prefix(3)
        let middle = phoneNumber.dropFirst(3).prefix(3)
        let rest = phoneNumber.dropFirst(6)

        return [zip, middle, rest]
            .filter { !$0.isEmpty }
            .joined(separator: "-")
            .prefix(12) // Limit to 12 characters including dashes
            .description
    }
}

struct EmailPassView_Previews: PreviewProvider {
    @State static var email = ""
    @State static var password = ""
    @State static var phoneNumber = ""
    static var previews: some View {
        EmailPassView(email: $email, password: $password, phoneNumber: $phoneNumber) {
            // Actions to perform on 'Next'
        }
    }
}
