//
//  ViewController.swift
//  FirebaseSignin
//
//  Created by Khuat Van Dung on 8/23/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    var dbRef: DatabaseReference!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var buttonLogin: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        print("Login with google account")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        let email = user.profile.email
        let urlPic = user.profile.imageURL(withDimension: 100)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            print("Logged to Firebase")
            self.dbRef = Database.database().reference()
            let userInfo = ["name": user?.displayName,
                            "email": email]
            self.dbRef.child("users").child(user!.uid).updateChildValues(userInfo)
            self.lbName.text = user?.displayName
            let data = try? Data(contentsOf: urlPic!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.imgAvatar.image = image
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}


