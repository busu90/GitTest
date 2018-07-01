//
//  User.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

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
}
