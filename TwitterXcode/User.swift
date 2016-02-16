//
//  User.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import SwiftyJSON

class User {
    
    private (set) var userToken: String
    private (set) var userId: String
    private (set) var username: String
    private (set) var iconURL: String
    
    init(json:JSON){
        self.userToken = json["userToken"].stringValue
        self.userId = json["userId"].stringValue
        self.username = json["username"].stringValue
        self.iconURL = json["iconURL"].stringValue
    }
    
    func getUserData() -> [String:String] {
        let userData = ["userToken": userToken,"userId": userId,"username": username,"iconURL": iconURL]
        return userData
    }
    
}