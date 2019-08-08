//
//  CommentsVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import  Firebase

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    
    // Variables
    var thought: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    //let firestore = Firestore.firestore()
    var username: String!
    
    var commentListener : ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self 
        tableView.delegate = self
        thoughtRef = Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        self.view.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentListener = Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId)
            .collection(COMMENTS_REF)
            .order(by: TIMESTAMP, descending: false)
            .addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("Error fetching comment \(error!)")
                return
            }
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        commentListener.remove()
    }
    @IBAction func addCommentTapped(_ sender: Any) {
        guard let commentTxt = addCommentTxt.text else { return }
        
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            
            let thoughtDocument: DocumentSnapshot
            
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            
            guard let oldNumComments = thoughtDocument.data()![NUM_COMMENTS] as? Int else { return nil }
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document()
            
            transaction.setData([COMMENT_TXT : commentTxt, TIMESTAMP : FieldValue.serverTimestamp(), USERNAME : self.username], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction faild: \(error)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.configurationCell(comment: comments[indexPath.row])
        return cell
    }
    
    
}
