//
//  CommentCell.swift
//  RNDM
//
//  Created by MacBook Pro on 8/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    

    func configurationCell(comment: Comment) {
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentTxt
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM, HH:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
    }
}
