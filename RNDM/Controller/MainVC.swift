//
//  MainVC.swift
//  RNDM
//
//  Created by MacBook Pro on 8/3/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory: String{
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}



class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ThoughtDelegate {
    
    
    // Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    //Variables
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    ////nakon logovoanja dodajemo da bi pamtili
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.estimatedRowHeight = 80
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600

        //
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.rowHeight = 96
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
        
        //setListener()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
        
    }
    
    func thoughtOptionsTapped(thought: Thought) {
        // This is where we create the alert to handle the deletion.
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete your thought?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Thought", style: .default) { (action) in
            // delete
            
            self.delete(collection: Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
                .collection(COMMENTS_REF)
                , completition: { (error) in
                    if let error = error {
                        debugPrint("Could not delete subcolection: \(error)")
                    } else {
                        
                        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
                            .delete(completion: { (error) in
                                if let error = error {
                                    debugPrint("Could not delete thought: \(error)")
                                } else {
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            })
                    }
            })
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func delete(collection: CollectionReference, batchSize: Int = 100, completition: @escaping (Error?) -> ()) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            guard let docset = docset else {
                completition(error)
                return
            }
            guard docset.count > 0 else {
                completition(nil)
                return
            }
            
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    completition(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completition: completition)
                }
                
            }
        }
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        thoughtsListener.remove()
        setListener()
    }
    
    func setListener() {
        
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollectionRef
                
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let err = error {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        //print(snapshot?.documents)
                        self.thoughts.removeAll()
                        
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
            }
        } else {
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let err = error {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        //print(snapshot?.documents)
                        self.thoughts.removeAll()
                        
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
            }
        }
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        setListener()
//    }
    
    //        thoughtsCollectionRef.getDocuments { (snapshot, error) in
    //            if let err = error {
    //                debugPrint("Error fetching docs: \(err)")
    //            } else {
    //                //print(snapshot?.documents)
    //                guard let snap = snapshot else { return }
    //                for document in snap.documents {
    //                    let data = document.data()
    //                    let username = data[USERNAME] as? String ?? "Anonymous"
    //                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
    //                    let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
    //                    let numLikes = data[NUM_LIKES] as? Int ?? 0
    //                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
    //                    let documentId = document.documentID
    //
    //                    let newThought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
    //                    self.thoughts.append(newThought)
    //                }
    //                self.tableView.reloadData()
    //            }
    //        }
    
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        thoughtsListener.remove()
//    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    func tableView(_  tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
            return cell
        } else { return UITableViewCell() }
    }
    
    //slanje na podataka na drugi prozor
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }
    }
    

}

