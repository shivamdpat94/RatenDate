import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging

// Define a custom AppDelegate
class CustomAppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()

        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Handle the granted permission or error
        }
        application.registerForRemoteNotifications() // Register for remote notifications

        // Set Messaging delegate
        Messaging.messaging().delegate = self

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Here you can send the deviceToken to Firebase or your server if needed
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("FAILED TO REGISTER FOR REMOTE NOTIFCATIONS!")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("GOT THE FCM TOKEN!")
    }

    // Add other necessary AppDelegate methods if needed
}

@main
struct RatenDateApp: App {
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    @StateObject var sessionManager = UserSessionManager()
    @State var isShowingLoadingScreen = true

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
