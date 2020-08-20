//
//  FavouriteVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

protocol FavouriteVMDelegate: AnyObject {
    func showError(_ text: String)
    func reloadTable()
    func openBreed(urls: [String], breedName: String)
}

class FavouriteVM {
    
    //MARK: - Inputs
    var cells = [FavouriteCellVMProtocol]()
    var delegate: FavouriteVMDelegate?
    
    private var breeds = [String : [String]]()
    private var subBreeds = [String]()
    private var breedsForData = [BreedForData]()
}

private extension FavouriteVM {
    func getData() {
        breedsForData.removeAll()
        guard let modelData = UserDefaults.standard.data(forKey: "breeds"),
            let model = try? PropertyListDecoder().decode([BreedForData].self, from: modelData) else { return }
        breedsForData = model
    }
    
    func getCells() {
        getData()
        cells.removeAll()
        for breed in breedsForData {
            let cell = FavoriteCellVM(name: breed.name, count: breed.urls.count)
            cells.append(cell)
        }
    }
}

extension FavouriteVM: FavouriteVMProtocol {
    
    func didSelectRow(at indexPath: IndexPath) {
        delegate?.openBreed(urls: breedsForData[indexPath.row].urls, breedName: breedsForData[indexPath.row].name)
    }
    
    func getList() {
        getCells()
        delegate?.reloadTable()
    }
}


