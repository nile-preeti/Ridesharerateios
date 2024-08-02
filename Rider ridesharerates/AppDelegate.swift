//
//  AppDelegate.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SDWebImage
import IQKeyboardManager
import CoreLocation
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI
import Stripe

 @main
class AppDelegate: UIResponder, UIApplicationDelegate{
  //  static var fcmToken: String?
    static var fcmToken: String?
    var recentToken = Data()
    var locationManager:CLLocationManager!
    
    var window: UIWindow?
    let conn = webservices()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AIzaSyDLAHWiWMZsT6uoevKBejTU-gn6vxcczJQ
        //  AIzaSyALNQ0K_N0bjPk2YfL2b_hoPt63aW9k9qc
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared().isEnabled = true
//        GMSServices.provideAPIKey("AIzaSyB-JC40RpeU21Ho_ex_olOh-7Cyi-IuIfQ")
//        GMSPlacesClient.provideAPIKey("AIzaSyDLAHWiWMZsT6uoevKBejTU-gn6vxcczJQ")
        // Old key 22/07/22
//        GMSServices.provideAPIKey("AIzaSyDJdca6mIsb_mOadvjvTMk9VHXtNFrO-58")
//        GMSPlacesClient.provideAPIKey("AIzaSyDJdca6mIsb_mOadvjvTMk9VHXtNFrO-58")

        
        // new key
        GMSServices.provideAPIKey("AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8")
        GMSPlacesClient.provideAPIKey("AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8")
     
        self.locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
      
        // stripe new test key
     //  STPAPIClient.shared.publishableKey = "pk_test_51N860MAyQV9SI7qTYWyZREnZsdywfMnNSqjGsnNSVKx8l3FECtoIFlCfYGKalSkht4QpHoCIkUXCbFxEhsQc09gL00vwRY7FCI"
       // getStripeToken()
        
      // STPAPIClient.shared.publishableKey = "pk_live_51N860MAyQV9SI7qTzSHJMq0AOEqGjphC8JbHHRqA6vTMPclelXDC97l8zPhtk5pwQhpwT39j4f05thTTnF30G58s00S2EufYNz"
       
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
//    
//    func getStripeToken() {
//        //  Indicator.shared.showProgressView(self.view)
//        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "paymentgatwaykey",authRequired: true) { [self] (value) in
//            if self.conn.responseCode == 1 {
//                print(value)
//                
//                // Ensure value is a dictionary
//                if let valueDict = value as? [String: Any] {
//                    // Retrieve the stripe_publish_key from the dictionary
//                    let stripe_publish_key = valueDict["stripe_pubish_key"] as? String ?? ""
//                    
//                    // Set the Stripe publishable key
//                    STPAPIClient.shared.publishableKey = stripe_publish_key
//                } else {
//                    print("Response is not a valid dictionary")
//                }
//            } else {
//                print("Failed to get response from server")
//            }
//        }
//    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate :  CLLocationManagerDelegate
{

    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }

    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error Location")
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //Access the last object from locations to get perfect current location
        if let location = locations.last {

            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            kCurrentLocaLat = "\(location.coordinate.latitude)"
            kCurrentLocaLong = "\(location.coordinate.longitude)"
            NSUSERDEFAULT.setValue("\(myLocation.latitude)", forKey: kCurrentLat)
            NSUSERDEFAULT.setValue("\(myLocation.longitude)", forKey: kCurrentLong)

            geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
                guard let placemark = placemark, error == nil else { return }
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                    
                    print("address1:", placemark.thoroughfare ?? "")
                    print("address2:", placemark.subThoroughfare ?? "")
                    print("city:",     placemark.locality ?? "")
                    print("state:",    placemark.administrativeArea ?? "")
                    print("zip code:", placemark.postalCode ?? "")
                    print("country:",  placemark.country ?? "")
                    let defaults = UserDefaults.standard
                    let dict = ["address1": placemark.thoroughfare ?? "", "address2": placemark.subThoroughfare ?? "" ,"city" : placemark.locality ?? "","state": placemark.administrativeArea ?? "", "zip code" : placemark.postalCode ?? "","country" : placemark.country ?? "" , "latitude" : myLocation.latitude , "longitude" : myLocation.longitude ] as [String : Any]
                    defaults.set(dict, forKey: "SavedCurrentLocation")
                    
                }
            }
        }
        manager.stopUpdatingLocation()

    }
}
extension AppDelegate : MessagingDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        recentToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        NSUSERDEFAULT.set(fcmToken, forKey: kFcmToken)
        Self.fcmToken = fcmToken
         let dataDict: [String: String] = ["token": fcmToken ?? ""]
         NotificationCenter.default.post(
           name: Notification.Name("FCMToken"),
           object: nil,
           userInfo: dataDict
         )
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
    
}
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil , userInfo: userInfo)
        
        let state = UIApplication.shared.applicationState
        if state == .active {
            // foreground alertRemoteNotification(request.content.userInfo as NSDictionary) }
            print("willPresent Method\(userInfo)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil , userInfo: userInfo)
           // completionHandler(<#UNNotificationPresentationOptions#>)
            completionHandler([.alert, .badge, .sound])
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        handleNotification(userInfo)
          }

          func handleNotification(_ userInfo: [AnyHashable: Any]) {
              // Extract any necessary information from the notification
              // For example, you might have a key in the userInfo dictionary that specifies the screen to navigate to
              
              // Get the root view controller of the window
              guard let rootViewController = window?.rootViewController as? UINavigationController else {
                  return
              }
              
              // Navigate to a different screen
//              let storyboard = UIStoryboard(name: "Main", bundle: nil)
//              let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
//              rootViewController.pushViewController(destinationViewController, animated: true)
          }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataForeground1"), object: nil , userInfo: userInfo)
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
}

