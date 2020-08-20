//
//  SubBreedsListVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

protocol SubBreedsListVMDelegate: AnyObject {
    func openBreed(breedName: String)
}

class SubBreedsListVM {
    
    // MARK: - Inputs
    var cells = [BreedsListCellVMProtocol]()
    var delegate: SubBreedsListVMDelegate?
    
    var breed: String
    var subBreeds: [String]?
    
    init(breed: String, subBreeds: [String]?) {
        self.breed = breed
        self.subBreeds = subBreeds
    }
}

private extension SubBreedsListVM {
    func getCells(for subBreeds: [String]?) -> [BreedsListCellVM] {
        guard let subBreeds = subBreeds else { return [BreedsListCellVM]() }
        return subBreeds.map({ BreedsListCellVM(name: $0, count: .zero)})
    }
}

extension SubBreedsListVM: SubBreedsListVMProtocol {
    func didSelectRow(at indexPath: IndexPath) {
        guard let breeds = subBreeds else { return }
        let breedName = "\(breed)/\(breeds[indexPath.row])"
        delegate?.openBreed(breedName: breedName)
    }
    
    func getList() {
        cells = getCells(for: subBreeds)
    }
}
