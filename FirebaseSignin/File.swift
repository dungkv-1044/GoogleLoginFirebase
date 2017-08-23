//
//  File.swift
//  FirebaseSignin
//
//  Created by Khuat Van Dung on 8/23/17.
//  Copyright © 2017 Khuat Van Dung. All rights reserved.
//

import Foundation

class UserInfo {
    var userId: String?
    var idToken: String?
    var fullName: String?
    var email: String?
    
    init(userId: String, idToken: String, fullName: String, email: String) {
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.email = email
    }
}
