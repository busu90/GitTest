//
//  User.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData

class User: NSObject, Codable{
    var login: String = ""
    var id: Int = 0
    var avatarUrl: String?
    var url: String = ""
    
    enum CodingKeys:String,CodingKey
    {
        case id
        case url
        case login
        case avatarUrl = "avatar_url"
    }
    override init() {
        super.init()
    }
    init(managedObject: UserDOM) {
        login = managedObject.login ?? ""
        id = Int(managedObject.id)
        avatarUrl = managedObject.avatarUrl
        url = managedObject.url ?? ""
    }
    
    func managedObject(context: NSManagedObjectContext) -> UserDOM {
        let user = UserDOM(context: context)
        user.id = Int64(id)
        user.login = login
        user.avatarUrl = avatarUrl
        user.url = url
        return user
    }
}
