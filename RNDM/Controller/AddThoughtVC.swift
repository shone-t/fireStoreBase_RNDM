//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/5/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {

    // Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    // Variables
    private var selectedCategory = "funny" //ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtTxt.delegate = self
        
        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought..."
        thoughtTxt.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            thoughtTxt.text = "My random thought..."
//            thoughtTxt.textColor = UIColor.lightGray
//        } else if thoughtTxt.text == "My random thought..." {
//            textView.text = ""
//            textView.textColor = UIColor.darkGray
//        }
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let username = userNameTxt.text else { return }
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            
            CATEGORY : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt.text,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME: username

//            "category" : selectedCategory,
//            "numComments" : 0,
//            "numLikes" : 0,
//            "thoughtTxt" : thoughtTxt.text,
//            "timestamp" : FieldValue.serverTimestamp(),
//            "username" : username
            
//        let CATEGORY = "category"
//        let NUM_COMMENTS = "numComments"
//        let NUM_LIKES = "numLikes"
//        let THOUGHT_TXT = "thoughtTxt"
//        let TIMESTAMP = "timestamp"
//        let USERNAME = "username"
            
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

}
