//
//  ThoughtCell.swift
//  RNDM
//
//  Created by MacBook Pro on 8/5/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    
    @IBOutlet weak var commentsNumLbl: UILabel!
    
    
    //Variables
    private var thought: Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
//Method 1
//        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
//            .setData([NUM_LIKES : thought.numLikes + 1], mergeFields: [NUM_LIKES])
        
        //Method 2
        Firestore.firestore().document("thoughts/\(thought.documentId!)")
        .updateData([NUM_LIKES : thought.numLikes + 1])
    }

    func configureCell(thought: Thought){
        self.thought = thought
        
        usernameLbl.text = thought.username
        //timeStampLbl.text = "\(thought.timestamp)"
        thoughtTxtLbl.text = thought.thoughtTxt
        likesNumLbl.text = String(thought.numLikes)
        
        commentsNumLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM, HH:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timeStampLbl.text = timestamp
    }

}
