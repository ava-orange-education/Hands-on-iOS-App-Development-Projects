//
//  User.swift
//  SaveUserData
//
//
//

import Foundation

class User {
    
    var userID: Int = 0
    var userName: String = ""
    var age: Int = 0
    var city: String = ""
    
    init(userID: Int, userName: String, age: Int, city: String) {
        self.userID = userID
        self.userName = userName
        self.age = age
        self.city = city
    }
}



