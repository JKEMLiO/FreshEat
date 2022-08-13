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
    private init(){}
    
    
}
