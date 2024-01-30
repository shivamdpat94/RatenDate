import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging

class CustomAppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureNotification(application: application)
        checkLaunchFromNotification(launchOptions: launchOptions)
        print("Print0")

        // Set up Firebase Auth state listener
        setupFirebaseAuthStateListener()

        return true
    }

    private func setupFirebaseAuthStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let email = user?.email {
                print("Print1")
                FCMTokenManager.fetchFCMToken { token in
                    if let token = token {
                        print("Print2")
                        FCMTokenManager.updateUserFCMToken(email: email, token: token)
                    }
                }
            }
        }
    }
    private func configureNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission(application: application)
    }
    
    
    


    

    
    
    private func requestNotificationPermission(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    private func checkLaunchFromNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            handleNotification(notification)
        }
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
        if let matchId = notification["matchId"] as? String {
            // Navigate to the chat screen using matchId
            // Implementation depends on your app's structure
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let email = Auth.auth().currentUser?.email, let fcmToken = fcmToken {
            updateUserFCMToken(email: email, token: fcmToken)
        }
    }
    private func updateUserFCMToken(email: String, token: String) {
        let usersRef = Firestore.firestore().collection("users")
        let userDoc = usersRef.document(email)

        userDoc.setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("Error updating FCM token: \(error)")
            } else {
                print("FCM token updated successfully for \(email)")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("fetching and updating token")
        fetchAndUpdateFCMToken()
    }




    private func fetchAndUpdateFCMToken() {
        if let email = Auth.auth().currentUser?.email {
            // Delay the token fetching process
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Delay of 5 seconds
                Messaging.messaging().token { [weak self] token, error in
                    if let error = error {
                        print("Error fetching FCM token: \(error)")
                    } else if let token = token {
                        // Using 'self?' to safely unwrap and call the method on 'self'
                        self?.updateUserFCMToken(email: email, token: token)
                    }
                }
            }
        }
    }


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("FAILED TO REGISTER FOR REMOTE NOTIFICATIONS: \(error)")
    }
    

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
