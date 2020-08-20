//
//  BreedService.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

typealias BreedResponse = BreedModel

protocol BreedServiceProtocol {
    func getList(breedName: String, completion: @escaping BreedGetCompletion) -> URLSessionTask?
}

class BreedService: BreedServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getList(breedName: String, completion: @escaping BreedGetCompletion) -> URLSessionTask? {
        let path = "/breed/\(breedName)/images"
        let params: [String : String?]? = [:]
        return networkService.getTask(path: path, parameters: params) { [weak self] (data, resp, error) in
            guard let self = self else { return }
            completion(self.networkService.parse(data: data, response: resp, error: error))
        }
    }
}
