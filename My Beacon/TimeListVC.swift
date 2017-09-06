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
    
    //vars
    var times = [Horario]()
    let messageDB = Database.database().reference().child("Times").child((Auth.auth().currentUser?.uid)!)
    
    //system functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        retrieveTime()
    }
    
    //actions
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            
        }
    }
    
    //custom functions
    func retrieveTime(){
        messageDB.keepSynced(true)
        messageDB.observe(.childAdded, with: {
            (snapshot) in
            let snap: [String: String] = snapshot.value as! [String : String]
            var horario = Horario()
            horario.horario = snap["horario"]
            horario.local = snap["local"]
            self.times.append(horario)
            let index = self.times.index(where: {$0.local == horario.local && $0.horario == horario.horario})
            let indexPath = IndexPath(row: index!, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .bottom)
        })
        messageDB.observe(.childRemoved, with: {
            (snapshot) in
            let snap: [String: String] = snapshot.value as! [String : String]
            var horario = Horario()
            horario.horario = snap["horario"]
            horario.local = snap["local"]
            let index = self.times.index(where: {$0.local == horario.local && $0.horario == horario.horario})
            self.times.remove(at: index!)
            let indexPath = IndexPath(row: index!, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .left)
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
        cell.detailTextLabel?.text = times[indexPath.row].horario
        cell.textLabel?.text = times[indexPath.row].local
        return cell
    }
}
