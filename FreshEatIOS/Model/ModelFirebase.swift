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
        db.collection("users").document(user.id!).setData(user.toJson())
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
    
    func editUser(user: User, key: String, value: String, completion:@escaping ()->Void){
        db.collection("users").document(user.id!).updateData([key : value])
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
    
    func isUserExists(id: String ,completion: @escaping (_ success: Bool)->Void){
        db.collection("users").document(id).getDocument {
            (document, error) in
            guard let document = document, document.exists else {
                print("User does not exist")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /*
     Authentication
     */
    
    func register(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
            if (result?.user) != nil {
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
                completion(true)
            }
        }
    }
    
    func signOut(completion: @escaping (_ success: Bool) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error Sign Out: \(signOutError)")
            completion(false)
        }
    }
    
    func isUserLoggedIn(completion:@escaping (_ success: Bool)->Void){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                completion(true)
            } else {
                completion(false)
            }
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
                let urlString = url?.absoluteString
                callback(urlString!)
            }
        }
    }
}
