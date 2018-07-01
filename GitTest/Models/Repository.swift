//
//  Repository.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData

class Repository: NSObject,Codable{
    var id: Int = 0
    var title: String = ""
    var name: String = ""
    var owner: User = User()
    var htmlUrl: String = ""
    var info: String?
    var createdAt: String = ""
    var stargazersCount: Int = 0
    var language: String?
    var languagesUrl: String = ""
    var forks: Int = 0
    var isFavorite = false
    
    enum CodingKeys:String,CodingKey
    {
        case id
        case title = "full_name"
        case owner
        case name
        case htmlUrl = "html_url"
        case info = "description"
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
        case language
        case languagesUrl = "languages_url"
        case forks
    }
    
    init(managedObject: RepositoryDOM) {
        id = Int(managedObject.id)
        name = managedObject.name ?? ""
        owner = User(managedObject: managedObject.owner!)
        title = managedObject.title ?? ""
        stargazersCount = Int(managedObject.stargazersCount)
        language = managedObject.language
        forks = Int(managedObject.forks)
        htmlUrl = managedObject.htmlUrl ?? ""
        createdAt = managedObject.createdAt ?? ""
        languagesUrl = managedObject.languagesUrl ?? ""
        info = managedObject.info
    }
    
    func managedObject(context: NSManagedObjectContext) -> RepositoryDOM {
        let repository = RepositoryDOM(context: context)
        repository.id = Int64(id)
        repository.name = name
        repository.owner = owner.managedObject(context: context)
        repository.info = info
        repository.stargazersCount = Int64(stargazersCount)
        repository.language = language
        repository.forks = Int64(forks)
        repository.htmlUrl = htmlUrl
        repository.createdAt = createdAt
        repository.title = title
        repository.languagesUrl = languagesUrl
        return repository
    }
}

extension Repository {
    static public func ==(left: Repository, right: Repository) -> Bool {
        return left.id == right.id
    }
}
