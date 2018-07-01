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
    static func getRequest(date: String) -> URLRequest{
        let url: URL! = URL(string: "https://api.github.com/search/repositories?q=created%3A%3E\(date)&sort=stars&order=desc")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return request
    }
}

class RepositoryProvider{
    private let apiClient = ApiClient(urlSessionConfiguration: URLSessionConfiguration.default,
                                            completionHandlerQueue: OperationQueue.main)
    private var nextPage: String?
    
    func fetchRepositories(forNextPage: Bool, ofDate: String, completionHandler: @escaping (Result<[Repository]>) -> Void) {
        let booksApiRequest: URLRequest!
        if forNextPage && nextPage == nil{
            completionHandler(.success([]))
            return
        }else if forNextPage{
            booksApiRequest = RepositoriesApiRequest.getRequest(url: nextPage!)
        }else{
            booksApiRequest = RepositoriesApiRequest.getRequest(date: ofDate)
        }
        apiClient.execute(request: booksApiRequest) {[weak self] (result: Result<ApiResponse<RepositoriesResponce>>) in
            switch result {
            case let .success(response):
                let repos = response.entity.items
                let headers = response.httpUrlResponse.allHeaderFields
                if let link = headers["link"]{
                    self?.nextPage = Util.getNextPageUri(fromHeaderString: link as! String)
                }
                completionHandler(.success(repos))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
