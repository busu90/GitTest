//
//  ApiClient.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
    public func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}

struct ApiResponse<T: Codable> {
    let entity: T
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            guard let data = data else {throw NSError()}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.entity = try JSONDecoder().decode(T.self, from: data)
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch {
            throw NSError(domain: "com.stanwood.GitTest",
                          code: 999,
                          userInfo: [NSLocalizedDescriptionKey: "A parsing error occured"])
        }
    }
}

protocol ApiClient {
    func execute<T>(request: URLRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void)
    func cancelAll()
}

class ApiClientImplementation: ApiClient{
    let urlSession: URLSession
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    // MARK: - ApiClient
    
    func execute<T>(request: URLRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) {
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NSError(domain: "com.stanwood.GitTest",
                                                   code: 999,
                                                   userInfo: [NSLocalizedDescriptionKey: "There was a problem with the request"])))
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(NSError(domain: "com.stanwood.GitTest",
                                                   code: httpUrlResponse.statusCode,
                                                   userInfo: [NSLocalizedDescriptionKey: "There was a problem with the request"])))
            }
        }
        dataTask.resume()
    }
    func cancelAll(){
        urlSession.getAllTasks { (tasks) in
            for task in tasks{
                task.cancel()
            }
        }
    }
}
