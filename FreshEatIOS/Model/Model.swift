//
//  Model.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 24/06/2022.
//

import Foundation

class Model{
    
    let firebaseModel = ModelFirebase()
    let dispatchQueue = DispatchQueue(label: "com.FreshEatIOS")
    static let instance = Model()
    static let postDataNotification = ModelNotificationBase("com.FreshEatIOS.postDataNotification")
    private init(){}
    
    
}

class ModelNotificationBase{
    let name:String
    init(_ name:String){
        self.name=name
    }
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: nil){ data in
            NSLog("got notify")
            callback()
        }
    }
    
    func post(){
        NSLog("post notify")
        NotificationCenter.default.post(name: Notification.Name(name), object: self)
    }
}
