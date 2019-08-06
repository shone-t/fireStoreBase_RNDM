//
//  LoginVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

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
        
    }
    @IBAction func createUserWasPressed(_ sender: Any) {
    }
    

}
