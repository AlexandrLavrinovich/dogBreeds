//
//  FavouriteFactory.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

protocol FavouriteFactoryProtocol {
    func makeVC() -> UIViewController
}

struct FavouriteFactory: FavouriteFactoryProtocol {
    func makeVC() -> UIViewController {
        let viewModel = FavouriteVM()
        let factory = FavouriteFactory()
        let vc = FavouriteVC(viewModel: viewModel, factory: factory)
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
