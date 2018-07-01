//
//  RepositoriesPresenter.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

protocol RepositoryCellView {
    func display(title: String)
    func display(description: String?)
    func display(profileImg: String?)
    func display(starCount: String)
    func display(isFavorite: Bool)
}

protocol RepositoriesPresenter {
    func periodChanged(to: Int)
    func viewDidLoad()
}

class RepositoriesPresenterImplementation: RepositoriesPresenter{
    private weak var view: RepositoriesView?
    private var repositories = [Repository]()
    private var repoProvider = RepositoryProvider()
    private var repoDataSource = RepositoriesCollectionDataSource()
    
    init(view: RepositoriesView) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setRepositoriesDataSource(source: repoDataSource)
        periodChanged(to: 0)
    }
    
    func periodChanged(to: Int) {
        repositories = []
        repoDataSource.setRepositories(repositories: [])
        view?.reloadRepozitories()
        var day = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        if to == 1{
            day = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        }else if to == 2{
            day = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.string(from: day)
        self.repoProvider.fetchRepositories(forNextPage: false, ofDate: utcTimeZoneStr) {(result) in
            switch result {
            case let .success(repos):
                self.handleNewRepositories(repos)
            case let .failure(error):
                self.view?.displayRepositoryFetchError(title: "Error", description: error.localizedDescription)
            }
        }
    }
    
    private func handleNewRepositories(_ repositories: [Repository]){
        let existing = self.repositories.count
        self.repositories.append(contentsOf: repositories)
        repoDataSource.setRepositories(repositories: repositories)
        view?.addRepositories(count: repositories.count, at: existing)
    }
    
}
