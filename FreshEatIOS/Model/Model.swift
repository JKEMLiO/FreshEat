//
//  Model.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 24/06/2022.
//

import Foundation
import UIKit
import CoreData

class Model{
    
    let firebaseModel = ModelFirebase()
    let dispatchQueue = DispatchQueue(label: "com.FreshEatIOS")
    static let instance = Model()
    static let postDataNotification = ModelNotificationBase("com.FreshEatIOS.postDataNotification")
    private init(){}
    
    
    /*
     User
     */
    
    func addUser(user:User, completion: @escaping ()->Void){
        firebaseModel.addUser(user: user){
            completion()
            Model.postDataNotification.post()
        }
    }
    
    func getUser(byId:String,completion: @escaping (User?)->Void){
        firebaseModel.getUserById(id: byId){
            user in
            completion(user)
        }
    }
    
    func getAllUsers(completion:@escaping ([User])->Void){
        firebaseModel.getAllUsers(){
            users in
            self.dispatchQueue.async{
                for user in users {
                    UserDao.addUser(user: user)
                }
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(UserDao.getAllUsers())
                }
            }
        }
    }
    
    /*
     Post
     */
    
    func getAllPosts(completion:@escaping ([Post])->Void){
        //get the Local Last Update data
        var lup = PostDao.localLastUpdated()
        NSLog("TAG POSTS_LAST_UPDATE " + String(lup))
        
        //fetch all updated records from firebase
        firebaseModel.getAllPosts(since: lup){ posts in
            //insert all records to local DB
            NSLog("TAG getAllPosts from Model count: \(posts.count)")
            self.dispatchQueue.async{
                for post in posts {
                    NSLog("TAG post.title " + post.title!)
                    NSLog("TAG Post is deleted? " + String(post.isPostDeleted!))
                    if !post.isPostDeleted!{
                        PostDao.addPost(post: post)
                    }
                    if post.lastUpdated > lup {
                        lup = post.lastUpdated
                    }
                }
                //update the local last update date
                PostDao.setLocalLastUpdated(date: lup)
      
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(PostDao.getAllPosts())

                }
            }
        }
    }
    
    func addPost(post:Post, completion: @escaping ()->Void){
        firebaseModel.addPost(post: post){
            completion()
            Model.postDataNotification.post()
        }
    }
    
    func deletePost(post:Post, completion:@escaping ()->Void){
        firebaseModel.editPost(post: post, data: ["isPostDeleted":true]){
            PostDao.delete(post: post)
            completion()
            Model.postDataNotification.post()
        }
    }
    
    /*
     Authentication
     */
    
    func register(email: String, password: String, completion: @escaping (_ success: Bool)->Void){
        firebaseModel.register(email: email, password: password, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ success: Bool)->Void){
        firebaseModel.signIn(email: email, password: password, completion: completion)
    }
    
    func signOut(completion: @escaping (_ success: Bool)->Void){
        firebaseModel.signOut(completion: completion)
    }
    
    /*
     Images
     */
    
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
}

class ModelNotificationBase{
    let name:String
    init(_ name:String){
        self.name=name
    }
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: nil){ data in
            NSLog("got notification")
            callback()
        }
    }
    
    func post(){
        NSLog("post notification")
        NotificationCenter.default.post(name: Notification.Name(name), object: self)
    }
}
