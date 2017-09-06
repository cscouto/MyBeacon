//
//  AppDelegate.swift
//  My Beacon
//
//  Created by Tiago Do Couto on 04/09/17.
//  Copyright © 2017 Tiago Do Couto. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 54094, minor: 58015, identifier: "Ponto")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
        
        self.beaconManager.delegate = self
        //self.beaconManager.requestWhenInUseAuthorization()
        self.beaconManager.requestAlwaysAuthorization()
        
        beaconManager.startMonitoring(for: beaconRegion)
        //beaconManager.startRangingBeacons(in: beaconRegion)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
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
    }

}

extension AppDelegate: ESTBeaconManagerDelegate{
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        if CLLocationManager.isRangingAvailable() {
            beaconManager.startRangingBeacons(in: region)
        }
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        beaconManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons.first!
            
            switch nearestBeacon.proximity {  
            case .immediate:
                let content = UNMutableNotificationContent()
                content.title = "Forget Me Not"
                content.body = "Are you forgetting something?"
                content.sound = .default()
                
                let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                if let user = Auth.auth().currentUser {
                    let timeDB = Database.database().reference().child("Times")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
                    let dateString = dateFormatter.string(from: Date())
                    let dict = ["message": dateString]
                    timeDB.child(user.uid).childByAutoId().setValue(dict){
                        (error, ref) in
                        if error == nil {
                        }
                    }
                }
                break
                
            default:
                break
            }
        }
    }
}

