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
    
    static func configureRepoList(forFavorites: Bool = false) ->  RepositoriesViewController{
        let repoListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "repoListController") as! RepositoriesViewController
        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
                  completionHandlerQueue: OperationQueue.main)
        let localRepoProvider = LocalRepositoryProviderInplementation()
        let repoProvider = RepositoryProviderImplementation(favoritesProvider: localRepoProvider, apiClient: apiClient)
        let presenter = RepositoriesPresenterImplementation(view: repoListView, repositoriesProvider: repoProvider, favoritesProvider: localRepoProvider, forFavorites: forFavorites)
        repoListView.presenter = presenter
        repoListView.searchDelegate = SearchDelegate(presenter: presenter)
        return repoListView
    }
    
    static func configureMainTabBar() ->  UITabBarController{
        let tabBarController = UITabBarController()
        let list = configureRepoList()
        let favs = configureRepoList(forFavorites: true)
        list.tabBarItem = UITabBarItem(title: "Repositories", image: #imageLiteral(resourceName: "RepositoriesTabIcon"), tag: 0)
        favs.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        tabBarController.viewControllers = [list, favs]
        return tabBarController
    }
    static func configureMainNav() -> UINavigationController{
        let navController = UINavigationController()
        let tab = configureMainTabBar()
        navController.viewControllers = [tab]
        return navController
    }
}
