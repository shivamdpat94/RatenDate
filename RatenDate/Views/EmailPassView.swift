import SwiftUI
import Firebase

struct EmailPassView: View {
    @Binding var email: String
    @Binding var password: String
    var onNext: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Your Credentials")) {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            Button("Next") {
                onNext()
            }
        }
    }
}

struct EmailPassView_Previews: PreviewProvider {
    @State static var email = ""
    @State static var password = ""
    
    static var previews: some View {
        EmailPassView(email: $email, password: $password) {
            // Actions to perform on 'Next'
        }
    }
}
