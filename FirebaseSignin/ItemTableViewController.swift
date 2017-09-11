//
//  ItemTableViewController.swift
//  FirebaseSignin
//
//  Created by Khuat Van Dung on 9/11/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class ItemTableViewController: UITableViewController {
    var dbRef: DatabaseReference!
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.age
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            let userID = Auth.auth().currentUser?.uid
            self.dbRef.child("users").child(userID!).child("items").child(item.id).removeValue()
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    private func loadItem() {
        let userID = Auth.auth().currentUser?.uid
        dbRef.child("users").child(userID!).child("items").observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                print("not found")
            } else {
                var loopCount = 1  //  count loops to see how may time trying to loop
                var _items : [Item] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot //each child is a snapshot
                    if snap.value != nil {
                        let key =  snap.key
                        let dict = snap.value as! [String: Any] // the value is a dictionary
                        let name = dict["name"] as! String
                        let age = dict["age"] as! String
                        let item = Item(id: key, name: name, age: age)
                        _items.append(item)
                        loopCount += 1
                    } else {
                        print("bad snap")
                    }
                    
                }
                self.items = _items
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
