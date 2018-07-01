//
//  Repository.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class Repository: NSObject,Codable{
    var id: Int = 0
    var title: String = ""
    var owner: User = User()
    var htmlUrl: String = ""
    var info: String?
    var createdAt: String = ""
    var stargazersCount: Int = 0
    var language: String?
    var languagesUrl: String = ""
    var forks: Int = 0
    
    enum CodingKeys:String,CodingKey
    {
        case id
        case title = "full_name"
        case owner
        case htmlUrl = "html_url"
        case info = "description"
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
        case language
        case languagesUrl = "languages_url"
        case forks
    }
}
