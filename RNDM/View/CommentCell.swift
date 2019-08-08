//
//  CommentCell.swift
//  RNDM
//
//  Created by MacBook Pro on 8/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}

class CommentCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    
    @IBOutlet weak var optionsBtn: UIImageView!
    
    // Variables
    private var comment: Comment!
    private var delegate: CommentDelegate!

    func configurationCell(comment: Comment, delegate: CommentDelegate) {

        
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentTxt
        
        optionsBtn.isHidden = true
        self.comment = comment
        self.delegate = delegate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM, HH:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionsBtn.isHidden = false
            optionsBtn.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionsBtn.addGestureRecognizer(tap)
        }
    }
    @objc func commentOptionsTapped() {
        delegate.commentOptionsTapped(comment: comment)
    }
}
