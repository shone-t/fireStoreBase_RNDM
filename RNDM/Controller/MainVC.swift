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

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    //Variables
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        setListener()
    }
    
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
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        thoughtsListener.remove()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    func tableView(_  tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else { return UITableViewCell() }
    }
}

