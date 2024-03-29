//
//  User.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 06/08/2022.
//

import Foundation
import Firebase

class User{
    
    public var name: String? = ""
    public var email: String? = ""
    public var avatarUrl: String? = ""
    
    init(){}
    
    init(user:UserDao){
        name = user.name
        email = user.email
        avatarUrl = user.avatarUrl
    }
}

extension User{
    static func FromJson(json:[String:Any])->User{
        let u = User()
        u.name = json["name"] as? String
        u.email = json["email"] as? String
        u.avatarUrl = json["avatarUrl"] as? String
        return u
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["name"] = self.name!
        json["email"] = self.email!
        json["avatarUrl"] = self.avatarUrl!
        return json
    }
}
