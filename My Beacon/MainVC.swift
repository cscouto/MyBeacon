//
//  MainVC.swift
//  My Beacon
//
//  Created by Tiago Do Couto on 04/09/17.
//  Copyright © 2017 Tiago Do Couto. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainVC: UIViewController{
    
    //outlets
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    //system functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtLogin.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Helvetica", size: 18)!])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Helvetica", size: 18)!])

        if let _ = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "showTimeList", sender: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //actions
    @IBAction func doLogin(_ sender: Any) {
        guard let login = txtLogin.text, login.characters.count > 0 else {
            SVProgressHUD.showError(withStatus: "Informe o email.")
            return
        }
        guard let password = txtPassword.text, password.characters.count > 0 else {
            SVProgressHUD.showError(withStatus: "Informe a senha.")
            return
        }
        Auth.auth().signIn(withEmail: login, password: password){
            (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "showTimeList", sender: nil)
            }else{
                SVProgressHUD.showError(withStatus: "Problema com autenticação, tente novamente.")
            }
        }
        
    }
    @IBAction func showRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "showRegister", sender: nil)
    }
    

}
