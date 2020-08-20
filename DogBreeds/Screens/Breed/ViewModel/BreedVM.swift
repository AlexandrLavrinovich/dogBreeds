//
//  BreedVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

typealias BreedGetCompletion = (Result<BreedResponse, Error>) -> Void

protocol BreedVMDelegate: AnyObject {
    func showError(_ text: String)
    func reloadTable()
    func reloadRow(index: Int)
}

class BreedVM {
    
    //MARK: - Inputs
    var cells = [BreedCellVMProtocol]()
    var delegate: BreedVMDelegate?
    var breedName = String()
    var favourName = String()
    
    private var urls = [String]()    
    private let service: BreedServiceProtocol
    private var getUrlsTask: URLSessionTask?
    
    init(urls: [String], breedName: String, service: BreedServiceProtocol) {
        self.urls = urls
        self.favourName = breedName
        self.service = service
    }
    
    init(breedName: String, service: BreedServiceProtocol) {
        self.breedName = breedName
        self.service = service
    }
}

private extension BreedVM {
    
    func requestImageUrls(breedName: String) {
        if breedName == "" {
            return
        }
        getUrlsTask?.cancel()
        getUrlsTask = service.getList(breedName: breedName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resp):
                self.handleSuccessForGet(resp: resp)
            case .failure( _):
                print("Fail")
            }
        }
    }
    
    func getCells(for urls: [String], liked: Bool) -> [BreedCellVM] {
        return urls.map({ BreedCellVM(name: self.breedName, url: $0, liked: liked)})
    }
    
    func getFavCells(for urls: [String]) -> [BreedCellVM] {
        return urls.map({ BreedCellVM(name: self.favourName, url: $0, liked: true)})
    }
    
    func handleSuccessForGet(resp: BreedModel) {
        cells.removeAll()
        urls.removeAll()
        cells = getCells(for: resp.message, liked: false)
        delegate?.reloadTable()
    }
    
    func getIndexByName(url: String) -> Int? {
        var index = 0
        for cell in cells {
            if cell.url == url {
                return index
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func checkSimilarUrl(url: String, urls: [String]) -> Bool {
        for checkUrl in urls {
            if checkUrl == url {
                return true
            }
        }
        return false
    }

    func getIndexUrl(url: String, urls: [String]) -> Int? {
        var index = 0
        for checkUrl in urls {
            if checkUrl == url {
                return index
            }
            index += 1
        }
        return nil
    }
    
    func removeLiked(name: String, url: String) {
        let modelDataTry = UserDefaults.standard.data(forKey: "breeds")
        if modelDataTry == nil {
            let model = [BreedForData(name: name, urls: [url])]
            let modelData = try? PropertyListEncoder().encode(model)
            UserDefaults.standard.set(modelData, forKey: "breeds")
        } else {
            guard let modelData = modelDataTry,
                var model = try? PropertyListDecoder().decode([BreedForData].self, from: modelData) else { return }
            var index = 0
            for breed in model {
                if breed.name == name {
                    if checkSimilarUrl(url: url, urls: breed.urls) {
                        guard let urlIndex = getIndexUrl(url: url, urls: breed.urls) else { return }
                        model[index].urls.remove(at: urlIndex)
                        let data = try? PropertyListEncoder().encode(model)
                        UserDefaults.standard.set(data, forKey: "breeds")
                        return
                    } else {
                        model[index].urls.append(url)
                        let data = try? PropertyListEncoder().encode(model)
                        UserDefaults.standard.set(data, forKey: "breeds")
                        return
                    }
                }
                index += 1
            }
            let newModel = BreedForData(name: name, urls: [url])
            model.append(newModel)
            let data = try? PropertyListEncoder().encode(model)
            UserDefaults.standard.set(data, forKey: "breeds")
        }
    }
}

extension BreedVM: BreedVMProtocol {

    func changeLike(url: String, name: String, liked: Bool) {
        guard let index = getIndexByName(url: url) else { return }
        let cell = BreedCellVM(name: cells[index].name, url: cells[index].url, liked: liked)
        cells[index] = cell
        removeLiked(name: name, url: url)
        delegate?.reloadRow(index: index)
    }
    
    func getList(breedName: String) {
        requestImageUrls(breedName: breedName)
    }
    
    func getFavouriteCells() {
        cells = getFavCells(for: self.urls)
    }
    
}


