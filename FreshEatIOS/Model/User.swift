//
//  User.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 06/08/2022.
//

import Foundation
import Firebase

class User{
    
    public var id: String? = ""
    public var name: String? = ""
    public var email: String? = ""
    public var avatarUrl: String? = ""
    public var lastUpdated: Int64 = 0
    
    init(){}
}

extension User{
    static func FromJson(json:[String:Any])->User{
        let u = User()
        u.id = json["id"] as? String
        u.name = json["name"] as? String
        u.email = json["email"] as? String
        u.avatarUrl = json["avatarUrl"] as? String
        if let lup = json["lastUpdated"] as? Timestamp{
            u.lastUpdated = lup.seconds
        }
        return u
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = self.id!
        json["name"] = self.name!
        json["email"] = self.email!
        json["avatarUrl"] = self.avatarUrl!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        return json
    }
}
