//
//  CreateUserVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CreateUserVC: UIViewController {

    // Variables
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    @IBAction func createBtnPressed(_ sender: Any) {
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
    }
    
}
