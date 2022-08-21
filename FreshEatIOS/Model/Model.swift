//
//  Model.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 24/06/2022.
//

import Foundation
import UIKit
import CoreData
import SwiftUI
import Firebase

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
        firebaseModel.addUser(user: user, completion: completion)
    }
    
    func editUser(user: User, data: [String:Any], completion:@escaping ()->Void){
        firebaseModel.editUser(user: user, data: data){
            UserDao.addUser(user: user)
            completion()
        }
    }
    
    func getUser(byEmail:String,completion: @escaping (User?)->Void){
        firebaseModel.getUserByEmail(email: byEmail){
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
        NSLog("POSTS_LAST_UPDATE " + String(lup))
        
        //fetch all updated records from firebase
        firebaseModel.getAllPosts(since: lup){ posts in
            //insert all records to local DB
            NSLog("getAllPosts from Model count: \(posts.count)")
            self.dispatchQueue.async{
                for post in posts {
                    NSLog("post.title " + post.title!)
                    NSLog("Post is deleted? " + String(post.isPostDeleted!))
                    if !post.isPostDeleted!{
                        PostDao.addPost(post: post)
                    }
                    else{
                        PostDao.delete(post: post)
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
    
    func editPost(post: Post, data: [String:Any], completion:@escaping ()->Void){
        var editedData = data
        editedData["lastUpdated"] = FieldValue.serverTimestamp()
        firebaseModel.editPost(post: post, data: editedData) {
            completion()
            Model.postDataNotification.post()
        }
    }
    
    func deletePost(post:Post, completion:@escaping ()->Void){
        firebaseModel.editPost(post: post, data: ["isPostDeleted":true, "lastUpdated":FieldValue.serverTimestamp()]){
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
    
    func isUserExists(email:String,completion: @escaping(_ success: Bool)->Void){
        firebaseModel.isUserExists(email: email, completion:completion)
    }
    
    func isUserLoggedIn(completion:@escaping (_ success: String?)->Void){
        firebaseModel.isUserLoggedIn(completion: completion)
    }
    
    func getCurrentUser(completion:@escaping (User?)->Void){
        firebaseModel.getCurrentUser(completion: completion)
    }
    
    /*
     Images
     */
    
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
    
    /*
     General
     */
    
    func isValidPassword(password:String) -> Bool{
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}")
        return passwordRegex.evaluate(with: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateFields(fields: [String]) ->Bool{
        for field in fields{
            if field == ""{
                return false
            }
        }
        return true
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

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

        func startLoading() {
            let activityIndicator = UIViewController.activityIndicator
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .large
            activityIndicator.color = .black
            DispatchQueue.main.async {
                self.view.addSubview(activityIndicator)
            }
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }

        func stopLoading() {
            let activityIndicator = UIViewController.activityIndicator
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            self.view.isUserInteractionEnabled = true
          }
}
