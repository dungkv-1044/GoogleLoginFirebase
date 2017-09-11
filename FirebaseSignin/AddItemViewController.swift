//
//  AddItemViewController.swift
//  FirebaseSignin
//
//  Created by Khuat Van Dung on 9/11/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
struct ErrorMessage {
    static let title = "Input field"
    static let messageName = "Please input name"
    static let messageAge = "Please input age"
    static let titleAction = "Close"
}
class AddItemViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    var dbRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        dbRef.keepSynced(true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if addEvent() == true {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addEvent() -> Bool {
        let name = tfName.text
        let age  = tfAge.text
        guard name != "" else {
            showAlertMessage(title: ErrorMessage.title, message: ErrorMessage.messageName, titleAction: ErrorMessage.titleAction)
            return false
        }
        guard age != "" else {
            showAlertMessage(title: ErrorMessage.title, message: ErrorMessage.messageAge, titleAction: ErrorMessage.titleAction)
            return false
        }
        let event = ["name": name, "age": age] as [String:Any]
        let userID = Auth.auth().currentUser?.uid
        let key = dbRef.child("users").child(userID!).child("items").childByAutoId().key
        self.dbRef.child("users").child(userID!).child("items").updateChildValues([key: event])
        return true
    }
    private func showAlertMessage(title: String, message: String, titleAction: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: titleAction, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
