import SwiftUI
import Firebase
import UserNotifications

// Define a custom AppDelegate
class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Handle the granted permission or error
        }
        application.registerForRemoteNotifications() // Register for remote notifications
        return true
    }

    // Add other necessary AppDelegate methods if needed
}

@main
struct RatenDateApp: App {
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    @StateObject var sessionManager = UserSessionManager()
    @State var isShowingLoadingScreen = true

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if isShowingLoadingScreen {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isShowingLoadingScreen = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(sessionManager)
            }
        }
    }
}
