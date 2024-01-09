import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoginSuccessful: Bool = false
    @State private var selectedTab: Int = 0 // Track the selected tab

    var body: some View {
        VStack(spacing: 0) {
            Text("LemonLime")
                .font(Font.custom("Nunito-Black", size: 20))

            TabView(selection: $selectedTab) {
                ProfileStackView()
                    .tabItem {
                        tabIcon("lemon favicon-32x32", isSelected: selectedTab == 0)
                        Text("Profiles")
                    }
                    .tag(0)

                RateView()
                    .tabItem {
                        tabIcon("rate favicon-32x32", isSelected: selectedTab == 1)
                        Text("Ratings")
                    }
                    .tag(1)

                LikesMeView()
                    .tabItem {
                        tabIcon("hearts favicon-32x32", isSelected: selectedTab == 2)
                        Text("LikesMe")
                    }
                    .tag(2)

                MatchView()
                    .tabItem {
                        tabIcon("chat favicon-32x32", isSelected: selectedTab == 3)
                        Text("Match")
                    }
                    .tag(3)

                SettingsView()
                    .tabItem {
                        tabIcon("profile favicon-32x32", isSelected: selectedTab == 4)
                        Text("Profile")
                    }
                    .tag(4)
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle("")
            .onAppear {
                self.isLoginSuccessful = true
            }
        }
        .background(
            Image("lemonfinal")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)
                .padding(.top, 22.9)
        )
    }

    private func tabIcon(_ imageName: String, isSelected: Bool) -> some View {
        Image(isSelected ? "green \(imageName)" : imageName) // Choose the green version if selected
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .if(colorScheme == .dark) {
                $0.colorInvert()
            }
    }
}

extension View {
    @ViewBuilder func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
