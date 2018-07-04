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
    func getNextRepoPage()
    func findRepos(query: String)
}

class RepositoriesPresenterImplementation: RepositoriesPresenter{
    private weak var view: RepositoriesView?
    private var repositories = [Repository]()
    private var repoProvider: RepositoryProvider
    private var favoritesProvider: LocalRepositoryProvider
    private var isDownloading = false
    private var forFavorites: Bool
    private var currStartDate: String!
    
    init(view: RepositoriesView, repositoriesProvider: RepositoryProvider, favoritesProvider: LocalRepositoryProvider, forFavorites: Bool) {
        self.view = view
        self.forFavorites = forFavorites
        self.repoProvider = repositoriesProvider
        self.favoritesProvider = favoritesProvider
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: favoritesProvider.getContext())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<AnyHashable>, inserts.count > 0 {
            let insertedRepos = inserts.filter({ (repo) -> Bool in
                repo is RepositoryDOM
            })
            guard insertedRepos.count > 0 else { return }
            let aux = insertedRepos.map({ (repoDOM) -> Repository in
                let repo = Repository(managedObject: repoDOM as! RepositoryDOM)
                repo.isFavorite = true
                return repo
            })
            if forFavorites{
                let toInsert = aux.filter { (repo) -> Bool in
                    !repositories.contains(repo)
                }
                repositories += toInsert
                repositories.sort { (first, second) -> Bool in
                    first.stargazersCount > second.stargazersCount
                }
            }else{
                for r in self.repositories{
                    if aux.contains(r){
                        r.isFavorite = true
                    }
                }
            }
            self.view?.reloadRepozitories()
        }else if let deletes = userInfo[NSDeletedObjectsKey] as? Set<AnyHashable>, deletes.count > 0 {
            let deletedRepos = deletes.filter({ (repo) -> Bool in
                repo is RepositoryDOM
            })
            guard deletedRepos.count > 0 else { return }
            let aux = deletes.map({ (repoDOM) -> Int in
                return Int((repoDOM as! RepositoryDOM).id)
            })
            var remaining: [Repository] = []
            for r in self.repositories{
                if aux.contains(r.id){
                    r.isFavorite = false
                }else{
                    remaining.append(r)
                }
            }
            if forFavorites{
                repositories = remaining
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
        currStartDate = utcTimeZoneStr
        getRepos(forNextPage: false, startDate: utcTimeZoneStr)
    }
    
    private func getRepos(forNextPage: Bool, startDate: String, query: String? = nil){
        isDownloading = true
        if !forNextPage{
            repoProvider.cancelAllRequests()
            repositories = []
            if query == nil{
                view?.reloadRepozitoriesAndSearch()
            }else{
                view?.reloadRepozitories()
            }
        }
        self.repoProvider.fetchRepositories(forNextPage: forNextPage, ofDate: startDate, query: query != nil ? query! : "") {[weak self](result) in
            switch result {
            case let .success(repos):
                if repos.count > 0{
                    self?.handleNewRepositories(repos)
                    self?.isDownloading = false
                }
            case let .failure(error):
                self?.isDownloading = false
                if !forNextPage && query == nil{
                    self?.view?.displayRepositoryFetchError(title: "Error", description: error.localizedDescription)
                }
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
    func getNextRepoPage() {
        guard !forFavorites && !isDownloading else {return}
        getRepos(forNextPage: true, startDate: currStartDate)
    }
    func findRepos(query: String) {
        let qq = query.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if forFavorites{
            filterFavorites(query: qq)
        }else{
            getRepos(forNextPage: false, startDate: currStartDate, query: qq)
        }
    }
    private func filterFavorites(query: String){
        if query.count > 0{
            repositories = repositories.filter({ (repo) -> Bool in
                repo.title.lowercased().contains(query.lowercased()) || (repo.info != nil && repo.info!.lowercased().contains(query.lowercased()))
            })
        }else{
            repositories = favoritesProvider.getFavorites()
        }
        view?.reloadRepozitories()
    }
}
