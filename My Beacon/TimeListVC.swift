//
//  TimeListVC.swift
//  My Beacon
//
//  Created by Tiago Do Couto on 05/09/17.
//  Copyright © 2017 Tiago Do Couto. All rights reserved.
//

import UIKit
import Firebase

class TimeListVC: UIViewController{
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveTime()
    }
    
    //vars
    var times = [String]()
    
    //custom functions
    func retrieveTime(){
        let messageDB = Database.database().reference().child("Times").child((Auth.auth().currentUser?.uid)!)
        messageDB.observe(.childAdded, with: {
            (snapshot) in
            let snap: [String: String] = snapshot.value as! [String : String]
            self.times.append(snap["message"]!)
            self.tableView.reloadData()
        })
    }
    
}

extension TimeListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
        cell.detailTextLabel?.text = times[indexPath.row]
        return cell
    }
}
