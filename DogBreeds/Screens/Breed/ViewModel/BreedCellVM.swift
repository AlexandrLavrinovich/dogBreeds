//
//  BreedCellVM.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation


protocol BreedCellVMProtocol {
    var name: String { get }
    var url: String { get }
    var liked: Bool { get set }
}

struct BreedCellVM: BreedCellVMProtocol {
    var name: String
    var url: String
    var liked: Bool
}
