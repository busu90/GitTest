//
//  DetailConfigurer.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class Configurator {
    
    static func configureDetails(forRepo: Repository) ->  RepositoryDetailViewController{
        let details = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailController") as! RepositoryDetailViewController
        
        let presenter = DetailsPresenterImplementation(view: details, repository: forRepo)
        details.presenter = presenter
        return details
    }
}
