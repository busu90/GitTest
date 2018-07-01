//
//  RepositoriesPresenter.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

protocol RepositoriesPresenter: class {
    func periodChanged(to: Int)
    func viewDidLoad()
    func getRepository(at: Int) -> Repository?
    func getRepoCount() -> Int
    func showDetailForRepo(at: Int)
}

class RepositoriesPresenterImplementation: RepositoriesPresenter{
    private weak var view: RepositoriesView?
    private var repositories = [Repository]()
    private var repoProvider = RepositoryProvider()
    
    init(view: RepositoriesView) {
        self.view = view
    }
    
    func viewDidLoad() {
        periodChanged(to: 0)
    }
    
    func periodChanged(to: Int) {
        repositories = []
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
        view?.addRepositories(count: repositories.count, at: existing)
    }
    
    func getRepository(at: Int) -> Repository? {
        if repositories.count > at{
            return repositories[at]
        }
        return nil
    }
    
    func getRepoCount() -> Int {
        return repositories.count
    }
    
    func showDetailForRepo(at: Int) {
        let detail = Configurator.configureDetails(forRepo: repositories[at])
        view?.pushNext(next: detail)
    }
    
}
