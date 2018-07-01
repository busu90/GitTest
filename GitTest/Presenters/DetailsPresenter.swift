//
//  DetailsPresenter.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

protocol DetailPresenter {
    func githubOpen()
    func getRepo() -> Repository
    func getTitle() -> String?
}

class DetailsPresenterImplementation: DetailPresenter{
    private weak var view: DetailView?
    private var repositori: Repository
    
    init(view: DetailView, repository: Repository) {
        self.view = view
        self.repositori = repository
    }
    
    func getRepo() -> Repository {
        return repositori
    }
    
    func githubOpen() {
        if let uri = URL(string: repositori.htmlUrl){
            view?.openUrl(url: uri)
        }
    }
    
    func getTitle() -> String? {
        return repositori.name
    }
    
}
