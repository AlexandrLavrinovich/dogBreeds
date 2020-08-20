//
//  FavouriteCellVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

protocol FavouriteCellVMProtocol {
    var name: String { get }
    var count: Int { get }
}

struct FavoriteCellVM: FavouriteCellVMProtocol {
    private(set) var name: String
    private(set) var count: Int
}
