//
//  LoginVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10
    }
    
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, let password = passwordTxt.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Erro sign in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }


}
