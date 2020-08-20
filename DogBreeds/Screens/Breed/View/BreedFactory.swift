//
//  BreedFactory.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

protocol BreedFactoryProtocol {
    func makeVC(breedName: String) -> UIViewController
    func makeFavouriteVC(urls: [String], breedName: String) -> UIViewController
}

struct BreedFactory: BreedFactoryProtocol {
    func makeVC(breedName: String) -> UIViewController {
        let networkService = NetworkService(session: URLSession.shared)
        let service = BreedService(networkService: networkService)
        let viewModel = BreedVM(breedName: breedName, service: service)
        let factory = BreedFactory()
        let vc = BreedVC(viewModel: viewModel, factory: factory)
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    func makeFavouriteVC(urls: [String], breedName: String) -> UIViewController {
        let networkService = NetworkService(session: URLSession.shared)
        let service = BreedService(networkService: networkService)
        let viewModel = BreedVM(urls: urls, breedName: breedName, service: service)
        let factory = BreedFactory()
        let vc = BreedVC(viewModel: viewModel, factory: factory)
        return vc
    }
}
