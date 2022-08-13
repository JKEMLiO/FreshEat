//
//  PostDao+CoreDataProperties.swift
//  FreshEatIOS
//
//  Created by Shiri Shmuely on 12/08/2022.
//

import Foundation
import CoreData

extension PostDao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostDao> {
        return NSFetchRequest<PostDao>(entityName: "PostDao")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var username: String?
    @NSManaged public var photo: String?
    @NSManaged public var postDescription: String?
    @NSManaged public var isPostDeleted: Bool
    @NSManaged public var lastUpdated: Int64

}

extension PostDao : Identifiable {

}
