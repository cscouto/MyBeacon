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
    var lastBeacon: CLBeacon?
    var beaconRegions = [CLBeaconRegion]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let beaconReg = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 54094, minor: 58015, identifier: "Ponto")
        beaconRegions.append(beaconReg)
        
        Database.database().isPersistenceEnabled = true
        
        self.beaconManager.delegate = self
        //self.beaconManager.requestWhenInUseAuthorization()
        self.beaconManager.requestAlwaysAuthorization()
        
        for beaconRegion in beaconRegions{
            beaconManager.startMonitoring(for: beaconRegion)
        }
        //beaconManager.startRangingBeacons(in: beaconRegion)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
        return true
    }
    
    func createNotification(title: String, message: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func storeDatabase(local: String){
        if let user = Auth.auth().currentUser {
            let timeDB = Database.database().reference().child("Times")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
            let dateString = dateFormatter.string(from: Date())
            let dict = ["horario": dateString, "local": local]
            timeDB.child(user.uid).childByAutoId().setValue(dict){
                (error, ref) in
                if error == nil {
                }
            }
        }
    }
}

extension AppDelegate: ESTBeaconManagerDelegate{
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        if CLLocationManager.isRangingAvailable() {
            beaconManager.startRangingBeacons(in: region)
        }
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        beaconManager.stopRangingBeacons(in: region)
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons.first!
            
            switch nearestBeacon.proximity {  
            case .immediate:
                
                if lastBeacon != nil {
                    if lastBeacon !=  nearestBeacon {
                        lastBeacon = nearestBeacon
                        //createNotification()
                        if lastBeacon?.major == 54094 && lastBeacon?.minor == 58015 {
                            storeDatabase(local: "Entrada")
                        }
                    }
                }else{
                    lastBeacon = nearestBeacon
                    //createNotification()
                    if lastBeacon?.major == 54094 && lastBeacon?.minor == 58015 {
                        storeDatabase(local: "Entrada")
                    }
                }
                break
                
            default:
                break
            }
        }
    }
}

