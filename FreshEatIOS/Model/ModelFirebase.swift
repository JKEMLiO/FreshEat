//
//  ModelFirebase.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 24/06/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import UIKit
import FirebaseAuth

class ModelFirebase{
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(){}
    
    /*
     User
     */
    
    func addUser(user:User,completion:@escaping ()->Void){
        db.collection("users").document(user.email!).setData(user.toJson())
        {
            error in
            if let err = error{
                print("Error adding user to Firebase: \(err)")
            }
            else{
                print("User added successfully to firebase")
            }
            completion()
        }
    }
    
    func editUser(user: User, data: [String:Any], completion:@escaping ()->Void){
        db.collection("users").document(user.email!).updateData(data)
        {
            error in
            if let err  = error {
                print("Error Updating User: \(err)")
            } else {
                print("User Updated Successfully")
            }
            completion()
        }
    }
    
    func isUserExists(email: String ,completion: @escaping (_ success: Bool)->Void){
        db.collection("users").document(email).getDocument {
            (document, error) in
            guard let document = document, document.exists else {
                print("User does not exist")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func getUserByEmail(email:String, completion:@escaping (User?)->Void){
        db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                for document in querySnapshot!.documents {
                    let user = User.FromJson(json: document.data())
                    completion(user)
                }
            }
        }
    }
    
    func getAllUsers(completion:@escaping ([User])->Void){
        db.collection("users").getDocuments() {
            (querySnapshot, error) in
            var users = [User]()
            if let err = error {
                print("Error getting users: \(err)")
                completion(users)
            } else {
                for document in querySnapshot!.documents {
                    let u = User.FromJson(json: document.data())
                    users.append(u)
                }
                completion(users)
            }
        }
    }
    
    /*
     Post
     */
    
    func getAllPosts(since:Int64, completion:@escaping ([Post])->Void){
        db.collection("posts").order(by: "timestamp",descending: true)
            .whereField("lastUpdated", isGreaterThanOrEqualTo: Timestamp(seconds: since, nanoseconds: 0))
            .getDocuments() {
            (querySnapshot, error) in
            var posts = [Post]()
            if let err = error {
                print("Error getting posts: \(err)")
                completion(posts)
            } else {
                for document in querySnapshot!.documents {
                    let p = Post.FromJson(json: document.data())
                    posts.append(p)
                }
                completion(posts)
            }
        }
    }
    
    func addPost(post:Post, completion:@escaping ()->Void){
        db.collection("posts").document(post.id!).setData(post.toJson())
        {
            error in
            if let err = error {
                print("Error adding post: \(err)")
            } else {
                print("Post added successfully")
            }
            completion()
        }
    }
    
    func editPost(post: Post, data: [String:Any], completion:@escaping ()->Void){
        db.collection("posts").document(post.id!).updateData(data)
        {
            error in
            if let err  = error {
                print("Error Updating Post: \(err)")
            } else {
                print("Post Updated Successfully")
            }
            completion()
        }
    }
    
    /*
     Authentication
     */
    
    func register(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
            if (result?.user) != nil {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                completion(true)
            } else {
                print("Register User Error \(String(describing: error))")
                completion(false)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("Sign In Error: \(error)")
                completion(false)
            } else {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                completion(true)
            }
        }
    }
    
    func signOut(completion: @escaping (_ success: Bool) -> Void){
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            completion(true)
        } catch let signOutError as NSError {
            print("Error Sign Out: \(signOutError)")
            completion(false)
        }
    }
    
    func isUserLoggedIn(completion:@escaping (_ success: Bool)->Void){
        if (Auth.auth().currentUser != nil){
            completion(true)
        }
        else{
            completion(false)
        }
    }
    
    func updateUserPassword(password: String , completion: @escaping (_ success: Bool)->Void){
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if error != nil {
                print("User password update Error: \(String(describing: error))")
                completion(false)
            } else {
                print("User password updated successfully")
                completion(true)
            }
        }
    }
    
    /*
     Images
     */
    
    func uploadImage(name:String, image:UIImage, callback: @escaping (_ url:String)->Void){
        let storageRef = storage.reference()
        let imageRef = storageRef.child(name)
        let data = image.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metaData){(metaData,error) in
            imageRef.downloadURL { (url, error) in
                if let err = error{
                    print("Error Uploading Picture to Firebase Storage: \(err)")
                }
                else{
                    let urlString = url?.absoluteString
                    print("Uploaded picture successfully")
                    callback(urlString!)
                }
            }
        }
    }
}
