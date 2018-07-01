//
//  RepositoriesPresenter.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData

protocol RepositoriesPresenter: class {
    func periodChanged(to: Int)
    func viewDidLoad()
    func getRepository(at: Int) -> Repository?
    func getRepoCount() -> Int
    func showDetailForRepo(at: Int)
    func handleFavorite(repoAt : Int)
    func showPeriodSelect() -> Bool
}

class RepositoriesPresenterImplementation: RepositoriesPresenter{
    private weak var view: RepositoriesView?
    private var repositories = [Repository]()
    private var repoProvider = RepositoryProvider()
    private var favoritesProvider = LocalRepositoryProvider()
    
    private var forFavorites: Bool
    
    init(view: RepositoriesView, forFavorites: Bool) {
        self.view = view
        self.forFavorites = forFavorites
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: favoritesProvider.context)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<RepositoryDOM>, inserts.count > 0 {
            let aux = inserts.map({ (repoDOM) -> Int in
                return Int(repoDOM.id)
            })
            for r in self.repositories{
                if aux.contains(r.id){
                    r.isFavorite = true
                }
            }
            self.view?.reloadRepozitories()
        }else if let deletes = userInfo[NSDeletedObjectsKey] as? Set<RepositoryDOM>, deletes.count > 0 {
            let aux = deletes.map({ (repoDOM) -> Int in
                return Int(repoDOM.id)
            })
            for r in self.repositories{
                if aux.contains(r.id){
                    r.isFavorite = false
                }
            }
            self.view?.reloadRepozitories()
        }
    }
    
    func viewDidLoad() {
        if forFavorites{
            repositories = favoritesProvider.getFavorites()
        }else{
            periodChanged(to: 0)
        }
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
    
    func handleFavorite(repoAt: Int) {
        let repo = repositories[repoAt]
        if repo.isFavorite{
            repo.isFavorite = false
            let success = favoritesProvider.removeFavorites(repository: repo)
            if !success{
                repo.isFavorite = true
            }
        }else{
            repo.isFavorite = true
            let success = favoritesProvider.saveToFavorites(repository: repo)
            if !success{
                repo.isFavorite = false
            }
        }
        view?.reloadRepozitories()
    }
    func showPeriodSelect() -> Bool {
        return !forFavorites
    }
}
