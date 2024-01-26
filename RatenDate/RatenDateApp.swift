import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging

// Define a custom AppDelegate
class CustomAppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self

        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Handle the granted permission or error
        }
        application.registerForRemoteNotifications() // Register for remote notifications

        // Set Messaging delegate
        Messaging.messaging().delegate = self

        
        
        
        // Check if launched from notification
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            handleNotification(notification)
        }
        
        
        
        
        
        
        // Fetch and update FCM token if the user is already logged in
        if let email = Auth.auth().currentUser?.email {
            fetchFCMToken { token in
                guard let token = token else { return }
                
                // Update the user's FCM token in Firestore or your backend
                self.updateUserFCMToken(email: email, token: token)
            }
        }
        
        return true
    }
    
    
    
    // Handle incoming notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Customize as needed
    }

    // Handle notification interaction
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo)
        completionHandler()
    }

    private func handleNotification(_ notification: [AnyHashable: Any]) {
        // Your existing logic here
        if let matchId = notification["matchId"] as? String {
            // Navigate to the chat screen using matchId
            // Implementation depends on your app's structure
        }
    }

    
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Here you can send the deviceToken to Firebase or your server if needed
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("FAILED TO REGISTER FOR REMOTE NOTIFCATIONS!")
    }
    
    func updateUserFCMToken(email: String, token: String) {
        let usersRef = Firestore.firestore().collection("users")
        let userDoc = usersRef.document(email)

        userDoc.setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("Error updating FCM token: \(error)")
            } else {
                print("FCM token updated successfully")
            }
        }
    }
    
    func fetchFCMToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                completion(nil)
            } else if let token = token {
                print("FCM registration token: \(token)")
                completion(token)
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        // Implement logic to send the token to your server or store it in Firestore associated with the user's profile
        print("FCM Token: \(fcmToken)")
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
