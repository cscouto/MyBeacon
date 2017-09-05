//
//  ViewController.swift
//  My Beacon
//
//  Created by Tiago Do Couto on 04/09/17.
//  Copyright © 2017 Tiago Do Couto. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    @IBOutlet weak var lblTest: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
        self.beaconManager.startMonitoring(for: self.beaconRegion)
        beaconManager.requestState(for: beaconRegion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
        beaconManager.stopMonitoring(for: beaconRegion)
    }
    

}

extension ViewController: ESTBeaconManagerDelegate {
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first {
            print(nearestBeacon.accuracy)
        }
    }
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        lblTest.text = "Entrei"
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        lblTest.text = "Sai"
    }
    func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        lblTest.text = "Mudou status"
    }
}

