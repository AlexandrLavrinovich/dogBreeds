//
//  BreedsListService.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

typealias BreedsListResponse = BreedsModel

protocol BreedsListServiceProtocol {
    func getList(completion: @escaping BreedsListGetCompletion) -> URLSessionTask?
}

class BreedsListService: BreedsListServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getList(completion: @escaping BreedsListGetCompletion) -> URLSessionTask? {
        let path = "/breeds/list/all"
        let params: [String : String?]? = [:]
        return networkService.getTask(path: path, parameters: params) { [weak self] (data, resp, error) in
            guard let self = self else { return }
            completion(self.networkService.parse(data: data, response: resp, error: error))
            
        }
    }
    
    
}
