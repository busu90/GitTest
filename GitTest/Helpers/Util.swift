//
//  Util.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

struct Util{
    static func getNextPageUri(fromHeaderString: String) -> String?{
        let links = fromHeaderString.components(separatedBy: ",")
        for link in links{
            let components = link.components(separatedBy:";")
            if components.count == 2 && components[1].contains("rel=\"next\""){
                let uri = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<> "))
                return uri
            }
        }
        return nil
    }
    static func getStarString(forStars: Int) -> String{
        if forStars < 1000{
            return String(forStars)
        }else if forStars <= 999999{
            return String(forStars / 1000)+"k"
        }else{
            return String(forStars / 1000000)+"m"
        }
    }
}
