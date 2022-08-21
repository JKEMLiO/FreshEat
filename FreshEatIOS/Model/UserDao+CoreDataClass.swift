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
            print("user fetch error core data\(error) \(error.userInfo)")
            return []
        }
    }
    
    static func addUser(user:User){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let u = UserDao(context: context)
        u.name = user.name
        u.email = user.email
        u.avatarUrl = user.avatarUrl
        do{
            try context.save()
        }catch let error as NSError{
            print("user add error core data \(error) \(error.userInfo)")
        }
    }
    
    static func editUser(email:String, data: [String:Any]){
        guard let context = context else {
            return
        }
        do{
            let fetchRequest: NSFetchRequest<UserDao> = UserDao.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            let usersDao = try context.fetch(fetchRequest)
            if(usersDao.count>0){
                let user = usersDao.first!
                for item in data{
                    user.setValue(item.value, forKey: item.key)
                }
                try context.save()
            }
            return
        }catch let error as NSError{
            print("Post Edit Core Data Error \(error) \(error.userInfo)")
            return
        }
    }
    
    static func getUser(byEmail:String)->User?{
        guard let context = context else {
            return nil
        }

        do{
            let userDao = try context.fetch(UserDao.fetchRequest())
            for uDao in userDao{
                if(uDao.email == byEmail){
                    return User(user:uDao)
                }
            }
            return nil
        }catch let error as NSError{
            print("user fetch error core data \(error) \(error.userInfo)")
            return nil
        }
    }
    
    static func deleteAllUsers(){
        guard let context = context else {
            return
        }
        
        do{
            let usersDao = try context.fetch(UserDao.fetchRequest())
            if(usersDao.count>0){
                for uDao in usersDao{
                    context.delete(uDao)
                }
            }
        }catch let error as NSError{
            print("users delete error core data \(error) \(error.userInfo)")
        }
        
        do{
            try context.save()
        } catch {
            print("Didn't save userDao after deleting all users.")
        }
    }
    
}
