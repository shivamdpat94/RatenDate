import SwiftUI

struct LikesMeView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @StateObject private var viewModel = LikesMeViewModel()


    var body: some View {
        ZStack {
            Image("bg FLAKES")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer(minLength: 80)

                HStack {
                    Button(action: {
                        // Action for back button
                    }) {
                        Image(systemName: "arrow.left").foregroundColor(.black)
                    }
                    Spacer()
                    Text("Likes Me").font(.headline).foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        // Action for settings button
                    }) {
                        Image("gear").resizable().frame(width: 30, height: 30).foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .shadow(color: .gray, radius: 5, x: 0, y: 5)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.userProfiles, id: \.email) { profile in
                            LikesMeUserView(userProfile: profile)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.currentUserEmail = sessionManager.email
        }
    }
}

struct LikesMeView_Previews: PreviewProvider {
    static var previews: some View {
        let dummySessionManager = UserSessionManager()
        dummySessionManager.email = "preview@example.com"
        return LikesMeView().environmentObject(dummySessionManager)
    }
}
