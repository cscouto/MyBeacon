//
//  RegisterVC.swift
//  My Beacon
//
//  Created by Tiago Do Couto on 05/09/17.
//  Copyright © 2017 Tiago Do Couto. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterVC: UIViewController {
    
    //outlets
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //system functions
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLogin.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Helvetica", size: 18)!])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Helvetica", size: 18)!])
    }
    
    //actions
    @IBAction func doRegister(_ sender: Any) {
        guard let login = txtLogin.text, login.characters.count > 0 else {
            SVProgressHUD.showError(withStatus: "Informe o email.")
            return
        }
        guard let password = txtPassword.text, password.characters.count > 0 else {
            SVProgressHUD.showError(withStatus: "Informe o password.")
            return
        }
        
        Auth.auth().createUser(withEmail: login, password: password){
            (user, error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }else{
                 SVProgressHUD.showError(withStatus: "Problema ao registrar-se, tente novamente.")
            }
        }
    }
    
}
