//
//  RepositoryProvider.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

struct RepositoriesApiRequest {
    static func getRequest(url: String) -> URLRequest{
        let url: URL! = URL(string: url)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return request
    }
    static func getRequest(date: String, query: String) -> URLRequest{
        let baseUrl = "https://api.github.com/search/repositories?q="
        let toFormat = "\(query)created:>\(date)&sort=stars&order=desc&per_page=70"
        let formatted = toFormat.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        
        return getRequest(url: baseUrl + formatted!)
    }
}

protocol RepositoryProvider{
    func fetchRepositories(forNextPage: Bool, ofDate: String, query: String, completionHandler: @escaping (Result<[Repository]>) -> Void)
    func cancelAllRequests()
}

class RepositoryProviderImplementation: RepositoryProvider{
    private let apiClient: ApiClient
    private var nextPage: String?
    private let favoritesProvider: LocalRepositoryProvider
    
    init(favoritesProvider: LocalRepositoryProvider, apiClient: ApiClient) {
        self.favoritesProvider = favoritesProvider
        self.apiClient = apiClient
    }
    
    func fetchRepositories(forNextPage: Bool, ofDate: String, query: String, completionHandler: @escaping (Result<[Repository]>) -> Void) {
        let repoApiRequest: URLRequest!
        if forNextPage && nextPage == nil{
            completionHandler(.success([]))
            return
        }else if forNextPage{
            repoApiRequest = RepositoriesApiRequest.getRequest(url: nextPage!)
        }else{
            let fQuery = query.count > 0 ? query + " " : ""
            repoApiRequest = RepositoriesApiRequest.getRequest(date: ofDate, query: fQuery)
        }
        apiClient.execute(request: repoApiRequest) {[weak self] (result: Result<ApiResponse<RepositoriesResponce>>) in
            switch result {
            case let .success(response):
                let repos = response.entity.items
                let headers = response.httpUrlResponse.allHeaderFields
                if let link = headers["Link"]{
                    self?.nextPage = Util.getNextPageUri(fromHeaderString: link as! String)
                }
                let favorited = self?.favoritesProvider.getFavorites(inList: repos)
                if favorited != nil && favorited!.count > 0{
                    for r in repos{
                        if favorited!.contains(r){
                            r.isFavorite = true
                        }
                    }
                }
                completionHandler(.success(repos))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func cancelAllRequests(){
        apiClient.cancelAll()
    }
}
