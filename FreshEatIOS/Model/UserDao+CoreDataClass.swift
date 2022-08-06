//
//  UserDao+CoreDataClass.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 06/08/2022.
//

import Foundation
import CoreData
import UIKit

@objc(UserDao)
public class UserDao: NSManagedObject {
    static var context:NSManagedObjectContext? = { () -> NSManagedObjectContext? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func getAllUsers()->[User]{
        guard let context = context else {
            return []
        }

        do{
            let userDao = try context.fetch(UserDao.fetchRequest())
            var uArray:[User] = []
            for uDao in userDao{
                uArray.append(User(user:uDao))
            }
            return uArray
        }catch let error as NSError{
            print("user fetch error \(error) \(error.userInfo)")
            return []
        }
    }
    
    static func addUser(user:User){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let u = UserDao(context: context)
        u.id = user.id
        u.name = user.name
        u.email = user.email
        u.avatarUrl = user.avatarUrl
        u.lastUpdated = user.lastUpdated
        
        do{
            try context.save()
        }catch let error as NSError{
            print("user add error \(error) \(error.userInfo)")
        }
    }
    
    static func getUser(byId:String)->User?{
        return nil
    }
    
    static func delete(user:User){
        
    }
    
    static func localLastUpdated() -> Int64{
        return Int64(UserDefaults.standard.integer(forKey: "USERS_LAST_UPDATE"))
    }
    
    static func setLocalLastUpdated(date:Int64){
        UserDefaults.standard.set(date, forKey: "USERS_LAST_UPDATE")
    }
}
