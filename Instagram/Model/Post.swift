//
//  Post.swift
//  Instagram
//
//  Created by Jo Michael on 8/6/23.
//

import UIKit
import ParseCore

class Post: PFObject, PFSubclassing {
    @NSManaged var media: PFFileObject
    @NSManaged var author: PFUser
    @NSManaged var caption: String?
    @NSManaged var commentsCount: Int
    @NSManaged var likesCount: Int
    
    static func parseClassName() -> String {
        return "Posts"
    }
}
