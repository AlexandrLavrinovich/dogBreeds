//
//  BreedsListCellVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

protocol BreedsListCellVMProtocol {
    var name: String { get }
    var count: Int { get }
}

struct BreedsListCellVM: BreedsListCellVMProtocol {
    private(set) var name: String
    private(set) var count: Int
}
