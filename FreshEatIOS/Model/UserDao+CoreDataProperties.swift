//
//  UserDao+CoreDataProperties.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 06/08/2022.
//

import Foundation
import CoreData

extension UserDao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDao> {
        return NSFetchRequest<UserDao>(entityName: "UserDao")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var avatarUrl: String?
}

extension UserDao : Identifiable {

}
