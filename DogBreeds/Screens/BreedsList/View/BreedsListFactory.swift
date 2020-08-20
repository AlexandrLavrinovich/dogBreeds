//
//  BreedsListFactory.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

protocol BreedsListFactoryProtocol {
    func makeVC() -> UIViewController
}

struct BreedsListFactory: BreedsListFactoryProtocol {
    func makeVC() -> UIViewController {
        let networkService = NetworkService(session: URLSession.shared)
        let breedsListService = BreedsListService(networkService: networkService)
        let viewModel = BreedsListVM(service: breedsListService)
        let factory = BreedsListFactory()
        let vc = BreedsListVC(viewModel: viewModel, factory: factory)
        vc.title = "breeds"
        vc.modalTransitionStyle = .crossDissolve
        let nc = MainNavigationController(rootViewController: vc)
        return nc
    }
}
