//
//  BreedsListVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

typealias BreedsListGetCompletion = (Result<BreedsListResponse, Error>) -> Void

protocol BreedsListVMDelegate: AnyObject {
    func openBreedList(breed: String, subBreeds: [String]?)
    func openBreed(breedName: String)
    func showError(_ text: String)
    func reloadTable()
    func indicator(show: Bool)
}

class BreedsListVM {
    
    // MARK: - Inputs
    var cells = [BreedsListCellVMProtocol]()
    var delegate: BreedsListVMDelegate?
    
    private let service: BreedsListServiceProtocol
    private var getBreedsListTask: URLSessionTask?
    private var breeds = [String : [String]]()
    private var breedsNames = [String]()
    
    init(service: BreedsListServiceProtocol) {
        self.service = service
    }
    
}

private extension BreedsListVM {
    
    func requestBreedsList() {
        getBreedsListTask?.cancel()
        delegate?.indicator(show: true)
        getBreedsListTask = service.getList() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resp):
                self.handleSuccessForGet(resp: resp)
                print("Success")
            case .failure(let error):
                print(error)
                print("Fail")
            }
            
        }
    }
    
    func getCells(for resp: BreedsModel) -> [BreedsListCellVM] {
        let names = resp.getNames()
        let dict = resp.message
        return names.map({ BreedsListCellVM(name: $0, count: dict[$0]?.count ?? .zero)})
    }
    
    func handleSuccessForGet(resp: BreedsModel) {
        cells.removeAll()
        breeds.removeAll()
        breedsNames.removeAll()
        cells = getCells(for: resp)
        breeds = resp.message
        breedsNames = resp.getNames()
        delegate?.indicator(show: false)
        delegate?.reloadTable()
    }
}

extension BreedsListVM: BreedsListVMProtocol {
    func getList() {
        requestBreedsList()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let count = breeds[breedsNames[indexPath.row]]?.count
        if count == 0 {
            delegate?.openBreed(breedName: breedsNames[indexPath.row])
        } else {
            let subBreeds = breeds[breedsNames[indexPath.row]]
            let breed = breedsNames[indexPath.row]
            delegate?.openBreedList(breed: breed, subBreeds: subBreeds)
        }
    }
}
