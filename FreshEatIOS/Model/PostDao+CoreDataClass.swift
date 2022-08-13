//
//  PostDao+CoreDataClass.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 12/08/2022.
//

import Foundation
import CoreData
import UIKit

@objc(PostDao)
public class PostDao: NSManagedObject {
    static var context:NSManagedObjectContext? = { () -> NSManagedObjectContext? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func getAllPosts()->[Post]{
        guard let context = context else {
            return []
        }

        do{
            let postDao = try context.fetch(PostDao.fetchRequest())
            var pArray:[Post] = []
            for pDao in postDao{
                pArray.append(Post(post:pDao))
            }
            return pArray
        }catch let error as NSError{
            print("post fetch error \(error) \(error.userInfo)")
            return []
        }
    }
    
    static func addPost(post:Post){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let p = PostDao(context: context)
        p.id = post.id
        p.username = post.username
        p.title = post.title
        p.photo = post.photo
        p.isPostDeleted = post.isPostDeleted!
        p.postDescription = post.postDescription
        p.lastUpdated = post.lastUpdated
        
        do{
            try context.save()
        }catch let error as NSError{
            print("post add error \(error) \(error.userInfo)")
        }
    }
    
    static func getPost(byId:String)->User?{
        return nil
    }
    
    static func delete(post:Post){
        
    }
    
    static func localLastUpdated() -> Int64{
        return Int64(UserDefaults.standard.integer(forKey: "POSTS_LAST_UPDATE"))
    }
        
    static func setLocalLastUpdated(date:Int64){
        UserDefaults.standard.set(date, forKey: "POSTS_LAST_UPDATE")
    }
    
}

