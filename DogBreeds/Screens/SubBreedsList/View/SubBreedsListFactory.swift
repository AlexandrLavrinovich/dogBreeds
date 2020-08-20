//
//  SubBreedsListFactory.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

protocol SubBreedsListFactoryProtocol {
    func makeVC(breed: String, subBreeds: [String]?) -> UIViewController
}

struct SubBreedsListFactory: SubBreedsListFactoryProtocol {
    func makeVC(breed: String, subBreeds: [String]?) -> UIViewController {
        let viewModel = SubBreedsListVM(breed: breed, subBreeds: subBreeds)
        let factory = SubBreedsListFactory()
        let vc = SubBreedsListVC(viewModel: viewModel, factory: factory)
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
