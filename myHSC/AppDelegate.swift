//
//  AppDelegate.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
//import FirebaseMessaging
import UserNotifications
import Flurry_iOS_SDK


// Hey Devansh in Future
// Note for myself:
// The secret file for APN service is located in devansh@dksources.com email
// Devansh - From Past

// Note to Ms. Hideg
// I studied OOP in Swift and I learned:
// By default, everything has access-control "Internal"
// This means files within the same module can have access to it
// This makes sense as long as it's nothing private such as password.
// I've adopted to use mostly the default access control "Internal" except rare places.
// Devansh - From Past



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Flurry.startSession("C6F5QT6R64H796TBF544", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        
//        Flurry.startSession("YOUR_API_KEY", with: builder)

        
        
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        Messaging.messaging().delegate = self
//        application.registerForRemoteNotifications()
        FirebaseApp.configure()

        // realm
        let config = Realm.Configuration(
            schemaVersion: 33,
            migrationBlock: { migration, oldSchemaVersion in
                // Any migration logic older Realm files may need
                if (oldSchemaVersion < 28) {
                    migration.deleteData(forType: "settings")
                }
                if (oldSchemaVersion < 33) {
                    migration.deleteData(forType: "mUser")
                    migration.deleteData(forType: "mTasks")
                    migration.deleteData(forType: "mCourses")
                    migration.deleteData(forType: "sysCourses")
                    migration.deleteData(forType: "mMarks")
                    migration.deleteData(forType: "mSnapizer")
                    migration.deleteData(forType: "storedImages")
                    migration.deleteData(forType: "mUnit")
                    migration.deleteData(forType: "weightSection")
                    migration.deleteData(forType: "schoolDays")
                    migration.deleteData(forType: "settings")
                    migration.deleteData(forType: "info")
                
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()

            // Override point for customization after application launch.
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                if error != nil {
                    print("Request authorization failed!")
                } else {
                    print("Request authorization succeeded!")
                    //                self.showAlert()
                    showAlert()
                }
            }

            
            func showAlert() {
                let objAlert = UIAlertController(title: "Alert", message: "Request authorization succeeded", preferredStyle: UIAlertController.Style.alert)
                
                objAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                //self.presentViewController(objAlert, animated: true, completion: nil)
//
//                UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
            }
   
        
            Setting.firstRun()
       
            return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
        }
        
//        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//            // If you are receiving a notification message while your app is in the background,
//            // this callback will not be fired till the user taps on the notification launching the application.
//            // TODO: Handle data of notification
//
//            // With swizzling disabled you must let Messaging know about the message, for Analytics
//            // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//            // Print message ID.
//            if let messageID = userInfo[gcmMessageIDKey] {
//                print("Message ID: \(messageID)")
//            }
//
//            // Print full message.
//            print(userInfo)
//
//            completionHandler(UIBackgroundFetchResult.newData)
//        }
//
        
    }

    

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        let dict = userInfo["aps"] as! NSDictionary
//        let message = dict["alert"]
//        print("%@", message!)
//    }
//
}



//
//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        // Change this to your preferred presentation option
//        completionHandler([.alert])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }
//
//}
//
//extension AppDelegate: MessagingDelegate {
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Message Data", remoteMessage.appData)
//    }
//
//}

// Firebase coutesy of
//https://www.youtube.com/watch?v=T242O6IIaIU
