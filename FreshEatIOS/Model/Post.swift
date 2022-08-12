//
//  Post.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 12/08/2022.
//

import Foundation
import Firebase

class Post{
    
    public var id: String? = ""
    public var title: String? = ""
    public var username: String? = ""
    public var postDescription: String? = ""
    public var photo: String? = ""
    public var isPostDeleted: Bool? = false
    
    init(){}
    
    init(post:PostDao){
        id = post.id
        title = post.title
        postDescription = post.postDescription
        username = post.username
        photo = post.photo
        isPostDeleted = post.isPostDeleted
    }
}

extension Post {
    static func FromJson(json:[String:Any])->Post{
        
        let p = Post()
        p.id = json["id"] as? String
        p.title = json["title"] as? String
        p.username = json["username"] as? String
        p.postDescription = json["postDescription"] as? String
        p.photo = json["photo"] as? String
        p.isPostDeleted = json["isPostDeleted"] as? Bool

        return p

    }
    
    func toJson()->[String:Any]{
        
        var json = [String:Any]()
        
        json["id"] = self.id!
        json["title"] = self.title!
        json["username"] = self.username!
        json["postDescription"] = self.postDescription!
        json["photo"] = self.photo
        json["isPostDeleted"] = self.isPostDeleted!

        return json
    }
}
