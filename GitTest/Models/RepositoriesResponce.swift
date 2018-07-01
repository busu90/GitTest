//
//  RepositoriesResponce.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class RepositoriesResponce: Codable{
    var items: [Repository]
    
    enum CodingKeys:String,CodingKey{
        case items
    }
}
